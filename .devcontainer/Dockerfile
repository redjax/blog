FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git ca-certificates locales bash \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN curl -fsSL https://mise.jdx.dev/install.sh | sh

ENV PATH="/root/.local/bin:/root/.local/share/mise/shims:${PATH}"

WORKDIR /workspace
CMD ["/bin/bash"]