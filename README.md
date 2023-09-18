# Dockerfile to build image for Mojo SDK
1. Clone the repo
1. Run the following command to build image. Remember to replace the `MODULAR_AUTH` environment variable with yours obtained from modular.com. Preferrably the build process is more likely to succeed in a cloud VM outside network-restricted area.

```shell
export MODULAR_AUTH="<REPLACE_WITH_YOUR_UNIQUE_TOKEN>" && \
export DOCKER_BUILDKIT=1 && \
docker build --no-cache \
    --secret id=modularauth,env=MODULAR_AUTH \
    -t <USE_YOUR_OWN_ID>/mojo:latest \
    -t <USE_YOUR_OWN_ID>/mojo:0.1 \
    .
```