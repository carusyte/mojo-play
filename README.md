# Easier to play with Mojo🔥

For those who are hampered setting local development environment for Mojo🔥

## VS Code Dev Container

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/carusyte/mojo-play)

If you already have VS Code and Docker installed, you can click the badge above or [here](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/carusyte/mojo-play) to get started. Clicking these links will cause VS Code to automatically install the Dev Containers extension if needed, clone the source code into a container volume, and spin up a dev container for use.

## Play in a Docker Container

```bash
docker run -it --rm carusyte/mojo bash
```

## Dockerfile to build image for Mojo SDK

1. Clone the repo
1. Run the following command to build Docker image. Remember to replace the `MODULAR_AUTH` environment variable with yours obtained from modular.com. Preferrably the build process is more likely to succeed in a cloud VM outside network-restricted area.

```bash
export MODULAR_AUTH="<REPLACE_WITH_YOUR_UNIQUE_TOKEN>" && \
export DOCKER_BUILDKIT=1 && \
docker build --no-cache \
    --secret id=modularauth,env=MODULAR_AUTH \
    -t <USE_YOUR_OWN_ID>/mojo:latest \
    -t <USE_YOUR_OWN_ID>/mojo:0.1 \
    .
```


