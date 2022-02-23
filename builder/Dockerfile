# BUILD IMAGES
# ============
FROM node:14-alpine as basics

RUN apk add --update --no-cache \
  autoconf \
  automake \
  bash \
  cargo \
  coreutils \
  curl \
  docker \
  g++ \
  gcc \
  git \
  jq \
  libc-dev \
  libc6-compat \
  libffi-dev \
  libpng-dev \
  make \
  openssh-client \
  parallel \
  python3 \
  python3-dev \
  py3-crcmod \
  py3-pip \
  py3-wheel \
  rustup \
  tar \
  unzip \
  util-linux \
  openssl-dev \
  postgresql-client \
  rsync

RUN pip3 install docker-compose
RUN yarn global add typescript

FROM golang:1.16-alpine3.13 as golang

# MAIN IMAGE
# ==========

FROM basics as builder

ENV INSTALL_BASE /usr/local/bin

COPY --from=golang /usr/local/* /usr/local/

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

RUN go get golang.org/x/tools/cmd/goimports
RUN apk add libc6-compat

ARG BUILD_DATE
ARG VERSION
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.authors="ops@monax.io"
LABEL org.opencontainers.image.description="Monax Infrastructure Builder Image"
LABEL org.opencontainers.image.vendor="Monax"
