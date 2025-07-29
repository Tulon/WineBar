#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <application_path> [arguments...]"
    exit 1
fi

if [ -z "$OUTDIR" -o ! '(' -d "$OUTDIR" ')' ]; then
    echo "The mandatory OUTDIR environment variable is not set or it's not a directory"
    exit 1
fi

if [ -z "$WINESERVER" ]; then
    echo "The mandatory WINESERVER environment variable is not set" \
        | tee "$OUTDIR/stdout.txt"
    exit 1
fi

if [ -z "$WINEPREFIX" ]; then
    # We invoke $WINESERVER at the end, which reads $WINEPREFIX.
    echo "The mandatory WINEPREFIX environment variable is not set" \
        | tee "$OUTDIR/stdout.txt"
fi

# The first argument is the application path
APPLICATION="$1"

# Shift the arguments so that $@ contains only the additional arguments
shift

# Execute the application with the remaining arguments
"$APPLICATION" "$@" > "$OUTDIR/stdout.txt" 2> "$OUTDIR/stderr.txt"
status=$?
echo "$status" > "$OUTDIR/status.txt"

# Wait for wineserver to exit. Note that it's wineserver that writes
# to the windows registry, so it's important to let it finish doing
# whatever it's busy with.

"$WINESERVER" -w

# This doesn't matter much, as muvm doesn't propagate the exit status.
exit $status
