FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git ca-certificates locales \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install mise ONLY - no activation, no shims during build
RUN curl https://mise.jdx.dev/install.sh | sh

# Set PATH for runtime (container start, VSCode, postCreate)
ENV PATH="/root/.local/bin:/root/.local/share/mise/shims:${PATH}"

WORKDIR /workspace
CMD ["/bin/bash"]
