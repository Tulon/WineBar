#!/bin/bash

# Exit on first error.
set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 x64|arm64 [version-name]"
    exit 1
fi

TARGET_ARCH="$1"
VERSION_NAME="$2"
HOST_ARCH="$(uname -m | awk '$0')"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
RELEASE_OR_DEBUG="release"
APPIMAGETOOL_FILENAME="appimagetool-${HOST_ARCH}.AppImage"
APPIMAGETOOL_URL="https://github.com/AppImage/appimagetool/releases/download/1.9.0/${APPIMAGETOOL_FILENAME}"

case "$TARGET_ARCH" in
    x64)
        ;;
    arm64)
        ;;
    *)
        echo "Unsupported target architecture \"${TARGET_ARCH}\"."
        echo "Supported architectures: x64, arm64."
        exit 1
esac

case "$HOST_ARCH" in
    x86_64)
        APPIMAGETOOL_SHA256="46fdd785094c7f6e545b61afcfb0f3d98d8eab243f644b4b17698c01d06083d1"
        ;;
    aarch64)
        APPIMAGETOOL_SHA256="04f45ea45b5aa07bb2b071aed9dbf7a5185d3953b11b47358c1311f11ea94a96"
        ;;
    *)
        echo "Unsupported host architecture \"${HOST_ARCH}\"."
        echo "Supported architectures: x86_64, aarch64."
        exit 1
esac

# On mobile platforms this would have to go up with every build.
# Fortunately, on Linux, it's not used anywhere.
BUILD_NUMBER=1

BUILD_NAME="${VERSION_NAME:-0.0.0}"

cd "$SCRIPT_DIR/../.."

mkdir -p build

./packaging/scripts/download_and_check_sha256.sh "${APPIMAGETOOL_URL}" \
"build/${APPIMAGETOOL_FILENAME}" "${APPIMAGETOOL_SHA256}"

chmod +x "build/${APPIMAGETOOL_FILENAME}"

flutter build linux "--${RELEASE_OR_DEBUG}" --target-platform "linux-${TARGET_ARCH}" \
--build-name "${BUILD_NAME}" --build-number "${BUILD_NUMBER}"

BUNDLE_DIR="build/linux/${TARGET_ARCH}/${RELEASE_OR_DEBUG}/bundle"
APP_DIR="build/linux/${TARGET_ARCH}/${RELEASE_OR_DEBUG}/WineBar-${TARGET_ARCH}.AppDir"
APP_IMAGE="build/linux/${TARGET_ARCH}/${RELEASE_OR_DEBUG}/WineBar-${TARGET_ARCH}.AppImage"

rm -rf "${APP_DIR}"
mkdir -p "${APP_DIR}"

cp -rp "${BUNDLE_DIR}/." "${APP_DIR}/"
cp -rp packaging/resources/common/wine_bar.desktop "${APP_DIR}/"
ln -s data/flutter_assets/packaging/resources/common/wine_bar.png "${APP_DIR}/wine_bar.png"
ln -s data/flutter_assets/packaging/resources/common/wine_bar.png "${APP_DIR}/.DirIcon"
cp -rp packaging/resources/AppImage/. "${APP_DIR}/"

"build/${APPIMAGETOOL_FILENAME}" "${APP_DIR}" "${APP_IMAGE}"
