# Source: https://hub.docker.com/_/ubuntu
FROM debian:unstable-slim@sha256:5ee6733c2db5bfe27184aaf83db7611fca0652706fd93704422b1a890ae2db73

LABEL maintainer="florian.stosse@gmail.com"
LABEL lastupdate="2025-12-07"
LABEL author="Florian Stosse"
LABEL description="CMake 4.2.0 using Debian unstable-slim base image"
LABEL license="MIT license"

# Cf. https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION=4.2.0
ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends sudo build-essential make ca-certificates wget && \
  update-ca-certificates && \
  apt-get full-upgrade -y

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh \
  -q -O /tmp/cmake-install.sh && \
  chmod u+x /tmp/cmake-install.sh && \
  mkdir /usr/bin/cmake && \
  /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake && \
  rm /tmp/cmake-install.sh
  
RUN groupadd -g 999 appuser && \
    mkdir -p /home/appuser && \
    useradd -r -d /home/appuser -u 999 -g appuser appuser && \
    chown -R appuser:appuser /home/appuser && \
    usermod -aG sudo appuser && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER appuser

ENV PATH="/usr/bin/cmake/bin:${PATH}"
