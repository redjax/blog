FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git ca-certificates locales bash sudo \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen en_US.UTF-8

ARG USERNAME=developer
ARG USER_UID=1001
ARG USER_GID=1001

RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME} \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USERNAME} \
 && chmod 0440 /etc/sudoers.d/${USERNAME}

USER developer
WORKDIR /home/developer

RUN curl -fsSL https://mise.jdx.dev/install.sh | bash

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV HOME=/home/developer
ENV PATH="/home/developer/.local/bin:/home/developer/.local/share/mise/shims:${PATH}"

USER developer

WORKDIR /workspace

CMD ["/bin/bash"]
