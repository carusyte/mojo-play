# syntax=docker/dockerfile:1.6

FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Avoid prompts with apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools, libraries, and utilities
RUN rm -rf /var/lib/apt/lists/* && \
    echo 'Acquire::Retries "10";' > /etc/apt/apt.conf.d/80-retries && \
    apt-get autoclean && \
    apt-get clean && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    ca-certificates \
    apt-utils \
    software-properties-common \
    build-essential \
    curl \
    vim \
    llvm \
    software-properties-common \
    apt-transport-https && \
    # Add deadsnakes PPA for latest Python versions
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.12

RUN ln -s /usr/bin/python3.12 /usr/bin/python

RUN pip install \
        --default-timeout=120000 \
        --trusted-host pypi.org \
        --trusted-host pypi.python.org \
        --trusted-host files.pythonhosted.org \
        --upgrade pip && \
    pip install \
        --default-timeout=120000 \
        --trusted-host pypi.org \
        --trusted-host pypi.python.org \
        --trusted-host files.pythonhosted.org \
        find-libpython

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

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]