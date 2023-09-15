# Start from the Ubuntu 20.04 base image
FROM ubuntu:20.04

# Build argument for Modular authentication code
ARG MODULAR_AUTH

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
    python3 python3-pip \
    apt-transport-https

# Create a symlink for python -> python3.10
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install --upgrade pip
RUN keyring_location=/usr/share/keyrings/modular-installer-archive-keyring.gpg && \
    curl -1sLf 'https://dl.modular.com/bBNWiLZX5igwHXeu/installer/gpg.0E4925737A3895AD.key' | gpg --dearmor >> ${keyring_location} && \
    curl -1sLf 'https://dl.modular.com/bBNWiLZX5igwHXeu/installer/config.deb.txt?distro=debian&codename=wheezy' > /etc/apt/sources.list.d/modular-installer.list && \
    apt-get update && \
    apt-get install -y modular
RUN modular auth $MODULAR_AUTH && \
    modular clean && \
    modular install mojo
RUN echo 'export MODULAR_HOME="/root/.modular"' >> ~/.bashrc
RUN echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> ~/.bashrc
RUN echo 'PS1="_# "' >> ~/.bashrc

# Verify Python version
RUN python3 --version
RUN python --version

CMD ["/bin/bash"]