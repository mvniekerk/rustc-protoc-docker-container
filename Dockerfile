# syntax=docker/dockerfile:experimental
FROM rust:1.72

RUN apt-get update
RUN apt-get install -y git openssh-client libssl-dev pkg-config build-essential

RUN apt-get install -y git openssh-client unzip curl && \
    export PROTOC_VERSION=$(curl -s "https://api.github.com/repos/protocolbuffers/protobuf/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+') && \
    curl -Lo protoc.zip "https://github.com/protocolbuffers/protobuf/releases/latest/download/protoc-${PROTOC_VERSION}-linux-x86_64.zip" && \
    unzip -q protoc.zip bin/protoc -d /usr/local && \
    chmod a+x /usr/local/bin/protoc && \
    protoc --version && \
    rm -rf protoc.zip

RUN mkdir /usr/src/app

WORKDIR /usr/src/app

RUN mkdir /root/.ssh/
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts