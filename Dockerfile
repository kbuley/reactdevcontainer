ARG ALPINE_VERSION=3.11

FROM qmcgaw/basedevcontainer
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=local
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.url="https://github.com/qdm12/reactdevcontainer" \
    org.opencontainers.image.documentation="https://github.com/qdm12/reactdevcontainer" \
    org.opencontainers.image.source="https://github.com/qdm12/reactdevcontainer" \
    org.opencontainers.image.title="React Dev container" \
    org.opencontainers.image.description="ReactJS development container for Visual Studio Code Remote Containers development"
USER root
# Install Alpine packages
RUN apk add -q --update --progress nodejs npm yarn
# Setup shells
COPY --chown=${USER_UID}:${USER_GID} shell/.zshrc-specific shell/.welcome.sh /home/${USERNAME}/
COPY shell/.zshrc-specific shell/.welcome.sh /root/
# Sets directories for NPM global packages
ENV NODE_PATH="/home/${USERNAME}/.npm-packages/lib/node_modules" \
    MANPATH="/home/${USERNAME}/.npm-packages/share/man"
RUN mkdir "/home/${USERNAME}/.npm-packages" && \
    echo "prefix = /home/${USERNAME}/.npm-packages" >> /home/${USERNAME}/.npmrc
ENV PATH=/home/${USERNAME}/.npm-packages/bin:$PATH
# Install some global NPM packages
RUN npm install -g create-react-app mocha react-native-cli eslint
USER ${USERNAME}
