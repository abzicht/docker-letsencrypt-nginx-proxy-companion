FROM alpine:3.8

LABEL maintainer="abzicht <abzicht@gmail.com>"

ENV DEBUG=false \
    DOCKER_HOST=unix:///var/run/docker.sock

# Install packages required by the image
RUN apk add --update \
        bash \
        ca-certificates \
        coreutils \
        curl \
        wget \
        jq \
        openssl \
    && rm /var/cache/apk/*

# Install docker-gen from github releases
ENV DOCKER_GEN_VERSION=0.7.4
ENV DOCKER_PLATFORM armel

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-$DOCKER_PLATFORM-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-$DOCKER_PLATFORM-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-$DOCKER_PLATFORM-$DOCKER_GEN_VERSION.tar.gz

# Install simp_le
COPY /install_simp_le.sh /app/install_simp_le.sh
RUN chmod +rx /app/install_simp_le.sh \
    && sync \
    && /app/install_simp_le.sh \
    && rm -f /app/install_simp_le.sh

COPY /app/ /app/

WORKDIR /app

ENTRYPOINT [ "/bin/bash", "/app/entrypoint.sh" ]
CMD [ "/bin/bash", "/app/start.sh" ]
