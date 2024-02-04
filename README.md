# Easier to Jumpstart with Mojo🔥

For those who are hampered setting up local environment for Mojo🔥, before next version with better installation experience is in place.

Related issues: [#800](https://github.com/modularml/mojo/issues/800), [#822](https://github.com/modularml/mojo/issues/822), [#825](https://github.com/modularml/mojo/issues/825), [#836](https://github.com/modularml/mojo/issues/836), [#838](https://github.com/modularml/mojo/issues/838), [#850](https://github.com/modularml/mojo/issues/850), [#866](<https://github.com/modularml/mojo/issues/866>)

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
