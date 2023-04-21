ARG ALPINE_VERSION=3.13
FROM alpine:${ALPINE_VERSION}

LABEL maintainer="Napadailo Yaroslav <experimental.rabbit.1986@gmail.com>"
LABEL desription="PJSUA image based on forked repository"
LABEL vcs-type="git"
LABEL vcs-url="https://github.com/man1207/pjproject.git"

WORKDIR /usr/local/src

RUN apk update && apk add --no-cache \
    curl \
    tar \
    build-base \
    alsa-lib-dev \
    ca-certificates \
    linux-headers

COPY . pjproject

RUN cd pjproject \
    && ./configure \
    && make dep \
    && make \
    && make install \
    && cp pjsip-apps/bin/pjsua-*gnu /usr/bin/pjsua \
    && apk del build-base \
    && rm -rf /var/cache/apk/* \
    && cd .. \
    && rm -rf pjproject

COPY . /opt/
ENV PATH="/opt:${PATH}"

WORKDIR /home

ENTRYPOINT ["pjsua"]
