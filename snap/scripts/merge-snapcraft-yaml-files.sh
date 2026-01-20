#!/bin/bash

set -e

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 file1.yaml [file2.yaml, ...]"
    exit 1
fi

if ! which yq >/dev/null 2>&1; then
    echo "Failed to find the yq program in PATH" >&2
    exit 1
fi

# Based on https://stackoverflow.com/a/67036496
yq eval-all '. as $item ireduce ({}; . *+ $item)' "$@"