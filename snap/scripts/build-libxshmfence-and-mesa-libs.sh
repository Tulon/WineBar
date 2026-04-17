#!/bin/bash

# Usage:
#
#   build-libxshmfence-and-mesa-libs.sh
#     --instdir <dir>
#     [--cross-arch <amd64|i386>]]
#     [--meson-cross-file <file>]    
#
# Assumptions:
#   * The libxshmfence sources are in /usr/local/src/libxshmfence.
#   * The mesa sources are in /usr/local/src/mesa.

set -ex

SCRIPT_NAME="$0"
INSTDIR=""
CROSS_ARCH=""
MESON_CROSS_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --instdir)
            INSTDIR="$2"
            shift 2
            ;;
        --cross-arch)
            CROSS_ARCH="$2"
            shift 2
            ;;
        --meson-cross-file)
            MESON_CROSS_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $SCRIPT_NAME"
            echo "       --instdir <dir>"
            echo "       [--cross-arch <amd64|i386>]]"
            echo "       [--meson-cross-file <file>]"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

if [[ -z "$INSTDIR" ]]; then
    echo "--instdir wasn't provided" >&2
    exit 1
fi

if [[ -n "$CROSS_ARCH" && -z "$MESON_CROSS_FILE" ]]; then
    echo "--cross-arch also requires --meson-cross-file" >&2
    exit 1
fi

if [[ -n "$MESON_CROSS_FILE" && ! -e "$MESON_CROSS_FILE" ]]; then
    echo "--meson-cross-file was provided but the file is not there" >&2
    exit 1
fi

NATIVE_ARCH="$(dpkg --print-architecture)"
if [[ -z "$CROSS_ARCH" ]]; then
    TARGET_ARCH="$NATIVE_ARCH"
else
    TARGET_ARCH="$CROSS_ARCH"
fi

native_arch_packages=(
    # Needed to install rust.
    curl
    ca-certificates
    
    # Provides the dpkg-architecture utility.
    dpkg-dev

    # Necessary even for cross builds, for building and/or running bindgen.
    gcc
    g++

    meson-1.7
    ninja-build
    cmake
    pkgconf-bin

    flex
    bison

    python3
    python3-mako
    python3-pycparser
    python3-yaml

    # Despite the name, this one only carries binaries, so we need a
    # native-arch version.
    xutils-dev

    # Also carries only binaries.
    glslang-tools

    # This one is a noarch package.
    libclc-20

    # These libraries are required in order to run the native mesa build tools.
    libllvm20
    libllvmspirvlib20.1
    libclang1-20
    libclang-cpp20
)

cross_arch_packages=(
    # Most of the list below was produced by running the following command:
    #
    #     sudo apt-rdepends --build-depends --follow=DEPENDS mesa
    #
    # on an Ubuntu 24.04 system, though you'll have to follow [1] first.
    # [1]: https://unix.stackexchange.com/a/614082
    libdrm-dev
    libelf-dev
    libexpat1-dev
    libglvnd-core-dev
    libllvmspirvlib-20-dev
    libsensors-dev
    libva-dev
    libvdpau-dev
    libvulkan-dev
    libwayland-dev
    libwayland-egl-backend-dev
    libx11-dev
    libx11-xcb-dev
    libxcb-dri2-0-dev
    libxcb-dri3-dev
    libxcb-glx0-dev
    libxcb-present-dev
    libxcb-randr0-dev
    libxcb-shm0-dev
    libxcb-sync-dev
    libxext-dev
    libxrandr-dev
    libxxf86vm-dev
    libzstd-dev
    zlib1g-dev

    # These didn't come from the above command. Perhaps
    # the version of Mesa in Ubuntu 24.04 weren't using
    # them yet.
    libarchive-dev
    libudev-dev
    x11proto-dev

    # The cross-arch version of pkgconfig just installs
    # symlinks pointing to the native-arch pkgconf executable
    # installed by the pkgconf-bin package.
    pkgconf
)

# These cross-arch packages conflict with the native-arch packages required
# for running the mesa tools (think mesa_clc). We don't install them with apt,
# but instead download them and exctract them into a separate root.
separate_root_cross_arch_packages=(
    llvm-20
    llvm-20-dev
    libllvm20
    llvm-20-tools
    libclang-20-dev
    libclang-cpp20-dev
    llvm-20-linker-tools
    spirv-tools
)

# Usage:
#
#     arr=("aaa" "bbb" "ccc")
#     array_append_suffix arr "ZZZ"
#     echo "${arr[@]}"
#
# Outputs:
#
#     aaaZZZ bbbZZZ cccZZZ
#
array_append_suffix() {
    local -n arr=$1
    local suffix="$2"
    
    for i in "${!arr[@]}"; do
        arr[$i]="${arr[$i]}${suffix}"
    done
}

CROSS_ARCH_TRIPLET=""
RUST_CROSS_TARGET=""

case "$CROSS_ARCH" in
    "")
        # Native build.
        ;;
    amd64)
        array_append_suffix cross_arch_packages ":amd64"
        array_append_suffix separate_root_cross_arch_packages ":amd64"
        native_arch_packages+=(
            gcc-x86-64-linux-gnu
            g++-x86-64-linux-gnu
            binutils-x86-64-linux-gnu
            libc6-dev-amd64-cross
            linux-libc-dev-amd64-cross
            libstdc++-13-dev-amd64-cross
        )
        CROSS_ARCH_TRIPLET="x86_64-linux-gnu"
        RUST_CROSS_TARGET="x86_64-unknown-linux-gnu"
        ;;
    i386)
        array_append_suffix cross_arch_packages ":i386"
        array_append_suffix separate_root_cross_arch_packages ":i386"
        native_arch_packages+=(
            gcc-i686-linux-gnu
            g++-i686-linux-gnu
            binutils-i686-linux-gnu
            libc6-dev-i386-cross
            linux-libc-dev-i386-cross
            libstdc++-13-dev-i386-cross
        )
        CROSS_ARCH_TRIPLET="i386-linux-gnu"
        RUST_CROSS_TARGET="i686-unknown-linux-gnu"
        ;;
    *)
        echo "Unrecognized cross-arch: $CROSS_ARCH" >&2
        echo "Supported values: amd64, i386" >&2
        exit 1
        ;;
esac

if [[ -n "$CROSS_ARCH" ]]; then
    # Add a package source for $CROSS_ARCH. 
    cat > /etc/apt/sources.list.d/ubuntu-cross-arch.sources <<EOF
Types: deb
URIs: http://archive.ubuntu.com/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Architectures: $CROSS_ARCH
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Architectures: $CROSS_ARCH
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

    # Restrict the built-in package sources to $NATIVE_ARCH.
    sed -i -r \
        -e '/^Architectures:/d' \
        -e "s@^(Components:.*)\$@\\1\\nArchitectures: $NATIVE_ARCH@g" \
        /etc/apt/sources.list.d/ubuntu.sources
    
    # Enable installing packages of the given architecture.
    dpkg --add-architecture $CROSS_ARCH
fi

apt-get update
apt-get upgrade -yq

# Install the required packages and their dependencies.
apt-get install -yq --no-install-recommends \
    "${native_arch_packages[@]}" "${cross_arch_packages[@]}"

# Note that dpkg-architecture was just installed.
NATIVE_ARCH_TRIPLET="$(dpkg-architecture -qDEB_HOST_MULTIARCH)"
if [[ -z "$CROSS_ARCH" ]]; then
    TARGET_ARCH_TRIPLET="$NATIVE_ARCH_TRIPLET"
else
    TARGET_ARCH_TRIPLET="$CROSS_ARCH_TRIPLET"
fi

# Download and extract some packages to a separate root.
rm -rf downloads separate-root
mkdir downloads
mkdir separate-root
(cd downloads && apt-get -yq  download "${separate_root_cross_arch_packages[@]}")
find downloads -name "*.deb" -exec dpkg -x "{}" separate-root/ ";"

# Cleanup
rm -rf downloads

# Usage:
#
#     prepend_prefix_to_pc_file "/path/to/file.pc" "/prefix/to/prepend"
#
prepend_prefix_to_pc_file() {
    local pc_file="$1"
    local prefix_to_prepend="$2"

    sed -i "$pc_file" -r \
        -e "s@(^prefix[[:space:]]*=[[:space:]]*)(.*)\$@\\1$prefix_to_prepend\\2@"
}

SEPARATE_ROOT="$PWD/separate-root"

# Fixup pkgconfig files in separate root. Fortunately, cmake exported
# packages are relocatable, so we don't have to do anything special
# about them, apart from setting CMAKE_PREFIX_PATH.
for file in separate-root/usr/lib/$TARGET_ARCH_TRIPLET/pkgconfig/*.pc; do
    prepend_prefix_to_pc_file "$file" "$SEPARATE_ROOT"
done

export "PKG_CONFIG_PATH=/usr/lib/$TARGET_ARCH_TRIPLET/pkgconfig:$SEPARATE_ROOT/usr/lib/$TARGET_ARCH_TRIPLET/pkgconfig"
export "CMAKE_PREFIX_PATH=$SEPARATE_ROOT/usr/lib/llvm-20/lib/cmake;$SEPARATE_ROOT/usr/lib/$TARGET_ARCH_TRIPLET/cmake"

# Install rust.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.91.0
export PATH="/root/.cargo/bin:$PATH"

# Install the required rust packages.
cargo install cbindgen bindgen-cli

# Install the rust cross target, if doing a cross-build.
if [[ -n "$RUST_CROSS_TARGET" ]]; then
    rustup target add "$RUST_CROSS_TARGET"

    # See here: https://github.com/mesonbuild/meson/issues/13591#issuecomment-2307996182
    export BINDGEN_EXTRA_CLANG_ARGS="--target=$RUST_CROSS_TARGET"
fi

#============================== Build libxshmfence ===========================#

libxshmfence_meson_setup_params=(
    --buildtype=release
    --prefix=/usr
    -Dshared-memory-dir=/dev/shm
)

if [[ -n "$MESON_CROSS_FILE" ]]; then
    libxshmfence_meson_setup_params+=("--cross-file=$MESON_CROSS_FILE")
fi

mkdir -p /work/libxshmfence-build
cd /usr/local/src/libxshmfence
meson setup "${libxshmfence_meson_setup_params[@]}" "/work/libxshmfence-build"
meson compile -C /work/libxshmfence-build
DESTDIR="$INSTDIR" meson install -C /work/libxshmfence-build

# Also install it to system directories, so that mesa build can find it.
meson install -C /work/libxshmfence-build

#================================= Build mesa ================================#

mesa_meson_setup_params=(
    --buildtype=release
    --prefix=/usr
    --sysconfdir=../etc
    -Db_ndebug=true
    -Dstrip=true
    -Dplatforms=x11,wayland
    -Dgallium-drivers=llvmpipe,softpipe,virgl,asahi,freedreno,etnaviv,radeonsi,iris,nouveau,tegra,vc4,v3d,lima,panfrost,zink,rocket,ethosu
    -Dgallium-va=enabled
    -Dgallium-mediafoundation=disabled
    -Dgallium-rusticl=true
    -Dvulkan-drivers=swrast,amd,asahi,broadcom,freedreno,panfrost,imagination,virtio,gfxstream,nouveau
    -Dvulkan-layers=device-select,overlay
    -Dgles1=enabled
    -Dgles2=enabled
    -Dopengl=true
    -Dgbm=enabled
    -Dglx=dri
    -Degl=enabled
    -Dglvnd=enabled
    -Dintel-rt=disabled
    -Dmesa-clc=system
    -Dprecomp-compiler=system
    -Dmicrosoft-clc=disabled
    -Dallow-fallback-for=libdrm
    -Dllvm=enabled
    -Dshared-llvm=enabled
    -Dvalgrind=disabled
    -Dbuild-tests=false
    -Dlibunwind=disabled
    -Dlmsensors=enabled
    -Dandroid-libbacktrace=disabled
    -Dglx-read-only-text=true
    -Dspirv-tools=enabled
)

if [[ -n "$MESON_CROSS_FILE" ]]; then
    mesa_meson_setup_params+=("--cross-file=$MESON_CROSS_FILE")
fi

if [[ "$TARGET_ARCH" = "arm64" ]]; then
    mesa_meson_setup_params+=(-Dteflon=true)
else
    # Teflon is only supported on arm64.
    mesa_meson_setup_params+=(-Dteflon=false)
fi

mkdir -p /work/mesa-build
cd /usr/local/src/mesa
meson setup "${mesa_meson_setup_params[@]}" "/work/mesa-build"
#|| cat /work/mesa-build/meson-logs/meson-log.txt && exit 1
meson compile -C /work/mesa-build
DESTDIR="$INSTDIR" meson install -C /work/mesa-build

# Cleanup
rm -rf /work/mesa-build
rm -rf separate-root

# Turn absolute paths to libraries in vulkan .json descriptors into relative
# ones. That's necessary for the native mesa build to be able to run in a
# Snap environment. Not sure if that's necessary for cross-builds that end up
# in fex-rootfs, but at least it doesn't hurt.
sed -i 's@\("library_path":[[:space:]]*"\)[^"]*/\([^"/]*"\)@\1\2@g' \
    $INSTDIR/usr/share/vulkan/*/*.json
