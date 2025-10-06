# Source: https://hub.docker.com/_/ubuntu
FROM debian:sid-slim@sha256:3e62bb802f97815491469a127cfef29a8266977b8fde5f0c09541d761b36a6a2

LABEL maintainer="florian.stosse@gmail.com"
LABEL lastupdate="2025-10-06"
LABEL author="Florian Stosse"
LABEL description="CMake 4.1.2 using Debian Sid slim base image"
LABEL license="MIT license"

# Cf. https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION=4.1.2
ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt update && \
  apt install -y --no-install-recommends sudo build-essential make ca-certificates wget && \
  update-ca-certificates && \
  apt full-upgrade -y

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

