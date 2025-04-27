# Source: https://hub.docker.com/_/ubuntu
FROM ubuntu:plucky-20250415@sha256:79efa276fdefa2ee3911db29b0608f8c0561c347ec3f4d4139980d43b168d991

LABEL maintainer="florian.stosse@gmail.com"
LABEL lastupdate="2025-04-27"
LABEL author="Florian Stosse"
LABEL description="CMake 4.0.1 using Ubuntu 25.04 base image"
LABEL license="MIT license"

# Cf. https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION=4.0.1
ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends sudo build-essential make ca-certificates wget && \
  update-ca-certificates && \
  apt-get dist-upgrade -y

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
