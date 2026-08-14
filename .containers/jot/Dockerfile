ARG NODE_IMG_TAG=trixie-slim

FROM node:${NODE_IMG_TAG}

RUN npm install -g @mariozechner/jot

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
