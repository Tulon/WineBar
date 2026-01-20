#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root" >&2
    exit 1
fi

SCRIPT_NAME="$0"
BINDIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --bindir)
            BINDIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $SCRIPT_NAME --bindir <dir>"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

if [ -z "$BINDIR" ]; then
    echo "--bindir wasn't provided" >&2
    exit 1
fi

if [ ! -d "$BINDIR" ]; then
    echo "The binary directory $BINDIR doesn't exist" >&2
    exit 1
fi

# Make sure $BINDIR is absolute.
BINDIR="$(readlink -f "$BINDIR")"

X86_64_INTERPRETER="$BINDIR/qemu-x86_64-static"
I386_INTERPRETER="$BINDIR/qemu-i386-static"

if [ ! -x "$X86_64_INTERPRETER" ]; then
    echo "$X86_64_INTERPRETER doesn't exist or is not an executable file" >&2
    exit 1
fi

if [ ! -x "$I386_INTERPRETER" ]; then
    echo "$I386_INTERPRETER doesn't exist or is not an executable file" >&2
    exit 1
fi

if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
    echo "Mounting /proc/sys/fs/binfmt_misc"
    mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
else
    # A repeat registration will fail, so we unregister all current handlers.
    echo "Unregistering all binfmt_misc handlers"
    echo -1 > "/proc/sys/fs/binfmt_misc/status"
fi

# See https://github.com/qemu/qemu/blob/7176f5d57439e26cf71055f49491c6baf20ae8bd/scripts/qemu-binfmt-conf.sh
X86_64_MAGIC='\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'
X86_64_MASK='\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'

I386_MAGIC='\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'
I386_MASK='\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'

I486_MAGIC='\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00'
I486_MASK='\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'

register_binfmt() {
    local interpreter_name="$1"
    local interpreter_path="$2"
    local magic="$3"
    local mask="$4"

    # As for the flags, the article [1] mentions that Docker uses the "POCF" flags.
    # Of those, only F seems to be really necessary, though I imagine Docker had
    # reasons for setting the others as well, so we do the same.
    # [1]: https://gergely.imreh.net/blog/2025/04/the-curious-case-of-binfmt-for-x86-emulation-for-arm-docker/
    flags=POCF

    echo ":$interpreter_name:M::$magic:$mask:$interpreter_path:$flags" > /proc/sys/fs/binfmt_misc/register
    echo "Registered binfmt_mist handler: $interpreter_name at $interpreter_path"
}

register_binfmt "qemu-x86_64" "$X86_64_INTERPRETER" "$X86_64_MAGIC" "$X86_64_MASK"
register_binfmt "qemu-i386" "$I386_INTERPRETER" "$I386_MAGIC" "$I386_MASK"
register_binfmt "qemu-i486" "$I386_INTERPRETER" "$I486_MAGIC" "$I486_MASK"