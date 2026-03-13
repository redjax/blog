FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    MISE_DIR=/mise \
    PATH="/mise/bin:/mise/shims:${PATH}"

RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    locales \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN curl https://mise.run | sh

RUN mise activate bash --shims-only >> /etc/bash.bashrc \
 && mise activate bash --shims-only >> /etc/profile \
 && echo 'eval "$(/mise/bin/mise activate bash)"' >> /etc/bash.bashrc

WORKDIR /workspace
CMD ["/bin/bash", "-i"]
