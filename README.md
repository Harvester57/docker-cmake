# Docker Image: CMake on Debian Sid Slim

This repository provides a Dockerfile to build a container image with a specific version of CMake installed on a Debian Sid Slim base. It includes essential build tools and creates a non-root user with `sudo` privileges for development.

## Features

*   **Base Image**: `debian:sid-slim` (Debian Unstable)
*   **CMake**: Version is configurable at build time via the `CMAKE_VERSION` argument.
*   **Build Tools**: `build-essential`, `make`
*   **Utilities**: `wget`, `ca-certificates`, `sudo`
*   **User**: Non-root user `appuser` (UID/GID 999) with passwordless `sudo` access. The default working directory for this user is `/home/appuser`.
*   **PATH**: CMake's `bin` directory is added to the system `PATH` for easy access.

## Prerequisites

*   Docker installed on your system.

## Building the Image

The Dockerfile uses a build argument `CMAKE_VERSION` to specify the version of CMake to install.

To build the image, navigate to the directory containing the Dockerfile and run:

```bash
docker build --build-arg CMAKE_VERSION=<valid_cmake_version> -t my-cmake-image .
```

Replace `<valid_cmake_version>` with a version number available from Kitware. For example, to use CMake 3.29.3:

```bash
docker build --build-arg CMAKE_VERSION=3.29.3 -t my-cmake-image .
```

You can find official CMake versions on the Kitware GitHub releases page. Ensure the version you choose has a corresponding `cmake-<VERSION>-linux-x86_64.sh` installer script.

## Running a Container

To run an interactive container using the image you built:

```bash
docker run -it --rm \
  -v "$(pwd):/work" \
  -w /work \
  my-cmake-image bash
```

This command will:
*   Start an interactive terminal (`-it`).
*   Automatically remove the container when it exits (`--rm`).
*   Mount your current host directory into `/work` inside the container (`-v "$(pwd):/work"`).
*   Set `/work` as the working directory inside the container (`-w /work`).
*   Use the image tagged as `my-cmake-image` (or your chosen tag).
*   Start a `bash` shell as the `appuser`.

## Using CMake

Once inside the container, you can verify the CMake installation and use it for your projects:

```bash
# Verify CMake version
cmake --version

# Example CMake project workflow
mkdir build
cd build
cmake ..
make
```

If you need root privileges for any command, you can use `sudo`:
```bash
sudo apt-get update
```

## Image Details & Labels

The Dockerfile includes the following labels:

*   **`maintainer`**: `florian.stosse@gmail.com`
*   **`lastupdate`**: `2025-05-29` (Note: This date is set in the Dockerfile.)
*   **`author`**: `Florian Stosse`
*   **`description`**: `"CMake 4.0.2 using Debian Sid slim base image"`
*   **`license`**: `MIT license`

## Dockerfile Overview

The `Dockerfile` performs the following main steps:

1.  **Base Image**: Starts from `debian:sid-slim` (pinned to a specific SHA256 hash for reproducibility).
2.  **Labels**: Sets metadata for the image (maintainer, author, description, etc.).
3.  **Build Arguments**:
    *   `CMAKE_VERSION`: Defines the CMake version to install (defaults to `4.0.2` - **requires override**).
    *   `DEBIAN_FRONTEND`: Set to `noninteractive` to prevent prompts during package installation.
4.  **Package Installation**:
    *   Updates package lists.
    *   Installs `sudo`, `build-essential`, `make`, `ca-certificates`, and `wget` without recommended packages to keep the image slim.
    *   Updates CA certificates.
    *   Performs a distribution upgrade (`apt-get dist-upgrade -y`).
5.  **CMake Installation**:
    *   Downloads the CMake installer script for the specified `CMAKE_VERSION` from Kitware's GitHub releases.
    *   Makes the script executable.
    *   Runs the installer, installing CMake into `/usr/bin/cmake` (binaries will be in `/usr/bin/cmake/bin`).
    *   Removes the downloaded installer script.
6.  **User Setup**:
    *   Creates a group `appuser` (GID 999).
    *   Creates a user `appuser` (UID 999) with home directory `/home/appuser`.
    *   Sets ownership of the home directory to `appuser`.
    *   Adds `appuser` to the `sudo` group and configures passwordless `sudo` access for this group.
7.  **User Switch**: Sets the default user for subsequent commands to `appuser`.
8.  **Environment Setup**: Adds CMake's binary path (`/usr/bin/cmake/bin`) to the `PATH` environment variable.

## License

The Dockerfile itself is licensed under the MIT License, as indicated by the `license` label.