FROM alpine:3.12 AS builder

LABEL \
    org.opencontainers.image.title="shadowsocks" \
    org.opencontainers.image.authors="metowolf <i@i-meto.com>, akafeng <i@sjy.im>" \
    org.opencontainers.image.source="https://github.com/akafeng/docker-shadowsocks"

ARG SS_VERSION="3.3.5"
ARG SS_URL="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${SS_VERSION}/shadowsocks-libev-${SS_VERSION}.tar.gz"

ARG SIMPLE_OBFS_URL="https://github.com/shadowsocks/simple-obfs.git"

ARG V2RAY_PLUGIN_VERSION="1.3.1"
ARG V2RAY_PLUGIN_URL="https://github.com/shadowsocks/v2ray-plugin/releases/download/v${V2RAY_PLUGIN_VERSION}/v2ray-plugin-linux-amd64-v${V2RAY_PLUGIN_VERSION}.tar.gz"

RUN set -eux \
    && apk add --no-cache \
        git \
        autoconf \
        automake \
        build-base \
        c-ares-dev \
        libev-dev \
        libtool \
        libsodium-dev \
        linux-headers \
        mbedtls-dev \
        pcre-dev \
    \
    && wget -O shadowsocks-libev.tar.gz ${SS_URL} \
    && tar -xzvf shadowsocks-libev.tar.gz \
    && cd shadowsocks-libev* \
    && ./configure --prefix=/usr/local --disable-documentation \
    && make install \
    \
    && cd .. \
    && git clone --depth=1 --recurse-submodules --shallow-submodules ${SIMPLE_OBFS_URL} simple-obfs \
    && cd simple-obfs \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local --disable-documentation \
    && make install \
    \
    && cd .. \
    && wget -O v2ray-plugin.tar.gz ${V2RAY_PLUGIN_URL} \
    && tar -xzvf v2ray-plugin.tar.gz \
    && mv v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin

######

FROM alpine:3.12

LABEL \
    org.opencontainers.image.title="shadowsocks" \
    org.opencontainers.image.authors="metowolf <i@i-meto.com>, akafeng <i@sjy.im>" \
    org.opencontainers.image.source="https://github.com/akafeng/docker-shadowsocks"

ENV SERVER_ADDR="0.0.0.0"
ENV SERVER_PORT="8388"
ENV PASSWORD=
ENV METHOD="aes-256-gcm"
ENV TIMEOUT="300"
ENV DNS="8.8.8.8,8.8.4.4"
ENV OBFS=
ENV PLUGIN=
ENV PLUGIN_OPTS=

COPY --from=builder /usr/local/bin/* /usr/local/bin/

RUN set -eux \
    && runDeps=$( \
        scanelf --needed --nobanner /usr/local/bin/ss-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
    ) \
    && apk add --no-cache \
        ca-certificates \
        rng-tools \
        tzdata \
        $runDeps \
    && sed -i "s@#!/bin/bash@#!/bin/sh@g" /usr/local/bin/ss-nat

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE ${SERVER_PORT}/tcp
EXPOSE ${SERVER_PORT}/udp
