# syntax=docker/dockerfile:1.6

# Start from the Ubuntu 20.04 base image
FROM ubuntu:20.04

# Avoid prompts with apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools, libraries, and utilities
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get autoclean && \
    apt-get clean && \
    apt-get update && \
    apt-get install -y \
    apt-utils \
    software-properties-common \
    build-essential \
    curl \
    vim \
    llvm \
    python3 python3-pip \
    apt-transport-https

RUN echo 'export LLVM_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer' >> ~/.bashrc

# Create a symlink for python -> python3.10
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install --upgrade pip
RUN pip3 install find-libpython

RUN libpython_path=$(find_libpython) && \
    echo '#!/bin/bash' > install_mojo.sh && \
    echo 'export MOJO_PYTHON_LIBRARY="'$libpython_path'"' | tee -a ~/.bashrc install_mojo.sh && \
    echo 'MODULAR_AUTH=`cat /run/secrets/modularauth`' >> install_mojo.sh && \
    echo 'curl https://get.modular.com | MODULAR_AUTH=$MODULAR_AUTH sh -' >> install_mojo.sh && \
    echo 'modular clean' >> install_mojo.sh && \
    echo 'modular install mojo' >> install_mojo.sh && \
    chmod +x install_mojo.sh

RUN --mount=type=secret,id=modularauth ./install_mojo.sh && \
    rm -f install_mojo.sh

RUN echo 'export MODULAR_HOME="/root/.modular"' >> ~/.bashrc
RUN echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> ~/.bashrc

CMD ["/bin/bash"]