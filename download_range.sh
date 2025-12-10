#!/bin/bash
# Download Slice-100K files by ID range
# Usage: ./download_range.sh <start_id> <end_id>
#
# Example: ./download_range.sh 50650001 50650063
#
# To find the IDs:
# 1. Go to https://figshare.com/s/9d084ff84f3822d2bf17
# 2. Right-click first file's Download button -> Copy link address
#    You'll get something like: https://figshare.com/ndownloader/files/50650001
#    The ID is: 50650001
# 3. Do the same for the last file to get the end ID

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <start_id> <end_id>"
    echo ""
    echo "Example: $0 50650001 50650063"
    echo ""
    echo "To find the file IDs:"
    echo "1. Go to https://figshare.com/s/9d084ff84f3822d2bf17"
    echo "2. Right-click the FIRST file's Download button"
    echo "3. Click 'Copy link address'"
    echo "4. The URL looks like: https://figshare.com/ndownloader/files/XXXXXXXX"
    echo "   The number at the end is the start_id"
    echo "5. Do the same for the LAST file to get end_id"
    exit 1
fi

START_ID=$1
END_ID=$2
DOWNLOAD_DIR="./dataset"

echo "Downloading files from ID $START_ID to $END_ID"
echo "Output directory: $DOWNLOAD_DIR"
echo "============================================"

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR" || exit 1

TOTAL=$((END_ID - START_ID + 1))
CURRENT=0

for id in $(seq "$START_ID" "$END_ID"); do
    ((CURRENT++))
    URL="https://figshare.com/ndownloader/files/$id"

    echo ""
    echo "[$CURRENT/$TOTAL] Downloading file ID: $id"

    wget -c \
        --content-disposition \
        --tries=5 \
        --retry-connrefused \
        --waitretry=5 \
        --timeout=60 \
        "$URL"

    if [[ $? -eq 0 ]]; then
        echo "✓ Success"
    else
        echo "✗ Failed - will retry later"
    fi

    sleep 2
done

echo ""
echo "============================================"
echo "Download complete! Files saved in: $DOWNLOAD_DIR"
