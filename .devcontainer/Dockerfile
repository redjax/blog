FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git ca-certificates locales bash sudo \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen en_US.UTF-8

ARG USERNAME=developer
ARG USER_UID=1000

RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
      useradd -m -s /bin/bash -u ${USER_UID} ${USERNAME}; \
    fi \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USERNAME} \
 && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN curl -fsSL https://mise.jdx.dev/install.sh | sh

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PATH="/home/developer/.local/bin:/home/developer/.local/share/mise/shims:${PATH}"
ENV HOME=/home/developer

RUN mkdir -p /workspace \
 && chown -R developer:developer /workspace /home/developer

USER developer

WORKDIR /workspace

CMD ["/bin/bash"]
