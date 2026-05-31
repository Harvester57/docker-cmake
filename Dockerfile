# https://hub.docker.com/hardened-images/catalog/dhi/debian-base
FROM dhi.io/debian-base:trixie-debian13-dev@sha256:37dadac289aa9a8cb37657e5ed92fad79b834d28312c00452febbac56c85de80

LABEL maintainer="florian.stosse@gmail.com"
LABEL lastupdate="2026-05-24"
LABEL author="Florian Stosse"
LABEL description="CMake 4.3.3 using Docker Hardened Image based on Debian 13"
LABEL license="MIT license"

# Cf. https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION=4.3.3
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo build-essential make ca-certificates wget && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh \
    -q -O /tmp/cmake-install.sh && \
    chmod u+x /tmp/cmake-install.sh && \
    mkdir /usr/bin/cmake && \
    /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake && \
    rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"

USER nonroot
