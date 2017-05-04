#!/bin/bash

ENV=$1

DEPLOYMENT=`pwd`/deployment
CONFIG=$DEPLOYMENT/$ENV

TEMPLATES=`pwd`/templates
TEMPLATES_OVERRIDE=`pwd`/$ENV

RUNTIMEROOT=`pwd`/runtime/$ENV
RUNTIME=$RUNTIMEROOT/`date +%Y%m%d%H%M%S`

if [ ! -f $CONFIG ]; then
    echo "No such environment $ENV"
    exit 0
fi

mkdir -p $RUNTIMEROOT
cp -r $TEMPLATES $RUNTIME

# IF overrides directory exist, copy it's contents
if [ -d $TEMPLATES_OVERRIDE ]; then
    cp -r $TEMPLATES_OVERRIDE/* $RUNTIME/
fi

while read line; do
    IFS='=' read -r -a VARS <<< "$line"
    # Skip comments
    if [[ "#" == ${VARS[0]:0:1} ]]; then
        continue
    fi
    # Skip empty lines
    if [[ "" == ${VARS[0]:0:1} ]]; then
        continue
    fi
    TAG=${VARS[0]}
    VAL=${VARS[1]}

    # Test if we have ENV VARs overriding values
    if [ ! -z ${!TAG} ]; then
        VAL=${!TAG}
    fi
    # Update files with configured values
    echo $TAG
    echo $VAL
    find $RUNTIME -type f -name "*.yml" | xargs sed -i "s~{$TAG}~$VAL~g"
done <$CONFIG
echo $RUNTIME
