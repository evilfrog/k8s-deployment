# Generate k8s files from templates

Use configuration file or ENV VARS to fill in "variables" in your k8s manifests.

# Quick start

1. Look into `deployment/test`, add/change some values.

2. Run `./bin/deployment.sh test`

3. Look into `runtime/test/DATE/` directory for the altered file

# Basic "How to"

1. Create k8s manifest templates in `templates` dir

Variables are named with ENV-like syntax and curly braces, ex. `{MY_VARIABLE}`.

2. Set some defaults in `deployment/environment` file

```
SOME_VARIABLE=value
SOME_OTHER_VARIABLE=other
```

3. Override default value with one provided in ENV (think: Jenkins!)

```
export SOME_OTHER_VARIABLE=bazinga
```

4. Run generator

```
./bin/deployment.sh environment
```

5. Look into `runtime` directory

```
cd runtime/environment/20170504105418/
```

6. See, values are updated :)
