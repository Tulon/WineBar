#!/bin/bash

# This script assumes the mesa sources are at /usr/local/src/mesa.
# The binaries it builds are installed to /opt/mesa-native-tools.

set -ex

packages_to_install=(
    gcc
    g++
    meson-1.7
    ninja-build
    pkgconf
    cmake

    bison
    flex

    python3
    python3-mako

    llvm-20-dev
    libllvmspirvlib-20-dev
    libclang-20-dev
    libclang-cpp20-dev

    libdrm-dev
    libclc-20-dev
    zlib1g-dev

    spirv-tools
)

apt-get update
apt-get upgrade -yq
apt-get install -yq --no-install-recommends "${packages_to_install[@]}"

meson_setup_params=(
    --prefix=/opt/mesa-native-tools
    --buildtype=release
    -Db_ndebug=true
    -Dstrip=true
    -Dplatforms=
    -Dgallium-drivers=
    -Dvulkan-drivers=
    -Dtools=asahi,panfrost,imagination
    -Dmesa-clc=enabled
    -Dprecomp-compiler=enabled
    -Dinstall-mesa-clc=true
    -Dinstall-precomp-compiler=true
)

mkdir -p /work/mesa-build
cd /usr/local/src/mesa
meson setup "${meson_setup_params[@]}" /work/mesa-build
meson compile -C /work/mesa-build
meson install -C /work/mesa-build

# Cleanup.
rm -rf /work/mesa-build
