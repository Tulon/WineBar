#!/bin/bash

set -ex

dpkg --add-architecture i386
apt-get update
apt-get upgrade -yq

# Install wine (both 32-bit and 64-bit versions).
# We don't need wine itself but we do need its dependencies.
# Also note that --no-install-recommends can't be used here,
# as some recommended packages are actually required to run
# Windows apps.
apt-get install -yq wine32 wine64

# Remove wine but keep its dependencies.
dpkg --get-selections | awk '{print $1}' | grep wine | xargs apt-get purge -yq

# Remove apt-related unneeded files.
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TODO: remove everything mesa and libxshmfence-related and
# copy our new mesa build.

