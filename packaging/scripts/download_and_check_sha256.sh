#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <URL> <destination_filename> <expected_sha256_hash>"
    exit 1
fi

URL="$1"
DESTINATION="$2"
EXPECTED_HASH="$3"

# Function to calculate the SHA256 hash
calculate_hash() {
    sha256sum "$1" | awk '{ print $1 }'
}

# Check if the file exists
if [ -f "$DESTINATION" ]; then
    # File exists, check the SHA256 hash
    CURRENT_HASH=$(calculate_hash "$DESTINATION")

    if [ "$CURRENT_HASH" == "$EXPECTED_HASH" ]; then
        echo "$DESTINATION already exists with the correct hash."
        exit 0
    else
        echo "$DESTINATION exists but has the wrong hash. Downloading again."
    fi
else
    echo "$DESTINATION does not exist. Downloading."
fi

# Download the file
curl --fail --retry 3 --retry-delay 5 -L -o "$DESTINATION" "$URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download $URL."
    exit 1
fi

# Verify the hash of the downloaded file
NEW_HASH=$(calculate_hash "$DESTINATION")
if [ "$NEW_HASH" == "$EXPECTED_HASH" ]; then
    echo "Download successful and the hash is correct."
    exit 0
else
    echo "Error: Downloaded file hash does not match the expected one."
    echo "Expected hash: $EXPECTED_HASH"
    echo "Actual hash:   $ACTUAL_HASH" 
    echo "Deleting the downloaded file."
    rm -f "$DESTINATION"
    exit 1
fi
