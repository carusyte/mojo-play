# syntax=docker/dockerfile:1.6

FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Avoid prompts with apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools, libraries, and utilities
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get autoclean && \
    apt-get clean && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    apt-utils \
    software-properties-common \
    build-essential \
    curl \
    vim \
    llvm \
    python3 python3-dev python3-pip \
    apt-transport-https

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install --upgrade pip && \
    pip3 install find-libpython

USER vscode

WORKDIR /build

RUN libpython_path=$(find_libpython) && \
    echo '#!/bin/bash' > install_mojo.sh && \
    echo 'export LLVM_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer' | tee -a ~/.bashrc install_mojo.sh && \
    echo 'export MOJO_PYTHON_LIBRARY="'$libpython_path'"' | tee -a ~/.bashrc install_mojo.sh && \
    echo 'MODULAR_AUTH=`cat /run/secrets/modularauth`' >> install_mojo.sh && \
    echo 'curl https://get.modular.com | MODULAR_AUTH=$MODULAR_AUTH sh -' >> install_mojo.sh && \
    echo 'modular clean' >> install_mojo.sh && \
    echo 'modular install mojo' >> install_mojo.sh && \
    chmod +x install_mojo.sh

RUN --mount=type=secret,id=modularauth,uid=1000 ./install_mojo.sh && \
    rm -f install_mojo.sh

RUN echo 'export MODULAR_HOME="$HOME/.modular"' >> ~/.bashrc
RUN echo 'export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"' >> ~/.bashrc

CMD ["/bin/bash"]