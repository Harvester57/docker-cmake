# Source: https://hub.docker.com/_/ubuntu
FROM ubuntu:jammy-20220130

LABEL maintainer "florian.stosse@safrangroup.com"
LABEL lastupdate "2022-02-02"
LABEL author "Florian Stosse"
LABEL description "CMake 3.22.2 using Ubuntu 22.04 base image"
LABEL license "MIT license"

# Cf. https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION=3.22.2

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends build-essential make ca-certificates wget && \
  update-ca-certificates

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh \
  -q -O /tmp/cmake-install.sh && \
  chmod u+x /tmp/cmake-install.sh && \
  mkdir /usr/bin/cmake && \
  /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake && \
  rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"
