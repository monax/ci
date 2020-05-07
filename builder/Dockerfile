# BUILD IMAGES
# ============
FROM node:13-alpine3.10 as basics

RUN apk add --update --no-cache \
  autoconf \
  automake \
  bash \
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
  nodejs \
  nodejs-npm \
  openssh-client \
  parallel \
  python \
  python3 \
  py-crcmod \
  py-pip \
  py3-pip \
  python-dev \
  tar \
  unzip \
  util-linux \
  openssl-dev \
  postgresql-client \
  yarn

RUN pip3 install pyyaml
RUN pip install docker-compose
RUN npm install -g typescript

FROM basics as tooling

ENV CLOUD_SDK_VERSION 225.0.0
ENV HELM_VERSION 3.0.0
ENV KUBECTL_VERSION 1.12.0
ENV INSTALL_BASE /usr/local/bin

## Install Helm Client
RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm $INSTALL_BASE/helm

## Install Kubernetes Client
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl $INSTALL_BASE/kubectl

## Install Google Cloud SDK
RUN curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  tar -xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  ln -s /google-cloud-sdk/lib /google-cloud-sdk/lib64

ENV PATH "$PATH:/google-cloud-sdk/bin"
RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

FROM golang:1.14.2-alpine3.11 as gopher

# MAIN IMAGE
# ==========

FROM tooling as builder

ENV INSTALL_BASE /usr/local/bin

COPY --from=gopher /usr/local/* /usr/local/

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

RUN go get golang.org/x/tools/cmd/goimports
# For delve to work
RUN go get github.com/go-delve/delve/cmd/dlv
RUN apk add libc6-compat

ARG BUILD_DATE
ARG VERSION
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.authors="ops@monax.io"
LABEL org.opencontainers.image.description="Monax Infrastructure Builder Image"
LABEL org.opencontainers.image.vendor="Monax"


