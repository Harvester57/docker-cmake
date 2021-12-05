# Source: https://hub.docker.com/_/gcc/
FROM gcc:11.2.0

LABEL maintainer "florian.stosse@safrangroup.com"
LABEL lastupdate "23-11-2021"
LABEL author "Florian Stosse"
LABEL description "CMake 3.22.0 using GCC 11.2 base image"
LABEL license "MIT license"

# Cf. https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION=3.22.0

RUN wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh \
  -q -O /tmp/cmake-install.sh && \
  chmod u+x /tmp/cmake-install.sh && \
  mkdir /usr/bin/cmake && \
  /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake && \
  rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"