FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git ca-certificates locales bash sudo \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen en_US.UTF-8

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
 && apt-get update && apt-get install -y sudo \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USERNAME} \
 && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN curl -fsSL https://mise.jdx.dev/install.sh | sh

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV MISE_INSTALL_PATH=/home/${USERNAME}/.local/bin/mise
ENV PATH="/home/${USERNAME}/.local/bin:/home/${USERNAME}/.local/share/mise/shims:${PATH}"

RUN mkdir -p /workspace && chown -R ${USERNAME}:${USERNAME} /workspace /home/${USERNAME}

USER ${USERNAME}

WORKDIR /workspace

CMD ["/bin/bash"]
