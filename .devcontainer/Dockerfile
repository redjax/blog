FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    ca-certificates \
    locales \
    build-essential \
    unzip \
    xz-utils \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen en_US.UTF-8

USER vscode

RUN curl -fsSL https://mise.jdx.dev/install.sh | sh \
 && echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV HOME=/home/vscode

WORKDIR /workspace
