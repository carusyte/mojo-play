# syntax=docker/dockerfile:1.6

FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Avoid prompts with apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools, libraries, and utilities and clean up in one layer
RUN echo 'Acquire::Retries "10";' > /etc/apt/apt.conf.d/80-retries && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-utils \
        build-essential \
        curl \
        vim \
        llvm \
        software-properties-common \
        apt-transport-https && \
    # Add deadsnakes PPA for latest Python versions
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y --no-install-recommends \
        python3.12 \
        python3-pip \
        python3-venv && \
    ln -s /usr/bin/python3.12 /usr/bin/python && \
    pip3 install --no-cache-dir \
        --default-timeout=120 \
        --trusted-host pypi.org \
        --trusted-host pypi.python.org \
        --trusted-host files.pythonhosted.org \
        find-libpython && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-*.list

USER vscode

WORKDIR /build

RUN echo '#!/bin/bash' > install_mojo.sh && \
    echo 'export LLVM_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer' | tee -a ~/.bashrc install_mojo.sh && \
    echo "export MOJO_PYTHON_LIBRARY=$(find_libpython)" | tee -a ~/.bashrc install_mojo.sh && \
    echo 'MODULAR_AUTH=`cat /run/secrets/modularauth`' >> install_mojo.sh && \
    echo 'curl https://get.modular.com | MODULAR_AUTH=$MODULAR_AUTH sh -' >> install_mojo.sh && \
    echo 'modular clean' >> install_mojo.sh && \
    echo 'modular auth $MODULAR_AUTH &&' >> install_mojo.sh && \
    echo 'modular install mojo' >> install_mojo.sh && \
    chmod +x install_mojo.sh && \
    --mount=type=secret,id=modularauth,uid=1000 ./install_mojo.sh && \
    rm -f install_mojo.sh

# Update PATH environment variable
RUN BASHRC=$( [ -f "$HOME/.bash_profile" ] && echo "$HOME/.bash_profile" || echo "$HOME/.bashrc" ) && \
    echo 'export MODULAR_HOME="$HOME/.modular"' >> "$BASHRC" && \
    echo 'export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"' >> "$BASHRC"

# Set default command
CMD ["/bin/bash"]