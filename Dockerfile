# https://hub.docker.com/hardened-images/catalog/dhi/debian-base
FROM dhi.io/debian-base:trixie-debian13-dev@sha256:61dc022a1908439c478ed4b00e883fe8a7a03540fac23a8aed61352e28e6ae07

LABEL org.opencontainers.image.authors="Florian Stosse <florian.stosse@gmail.com>"
LABEL org.opencontainers.image.created="2026-10-04"
LABEL org.opencontainers.image.description="CMake 4.4.4 using Docker Hardened Image based on Debian 13"
LABEL org.opencontainers.image.licenses="MIT license"

# Cf. https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION=4.4.4
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
