#!/bin/bash
# Download Slice-100K dataset files from a URL list
# Usage: ./download_from_urls.sh [urls_file]

URLS_FILE="${1:-urls.txt}"
DOWNLOAD_DIR="./dataset"
LOG_FILE="download.log"

# Check if urls file exists
if [[ ! -f "$URLS_FILE" ]]; then
    echo "Error: URLs file '$URLS_FILE' not found!"
    echo ""
    echo "To create the URLs file:"
    echo "1. Go to https://figshare.com/s/9d084ff84f3822d2bf17"
    echo "2. Open browser console (F12 -> Console)"
    echo "3. Run this JavaScript to get all download links:"
    echo ""
    echo '   // Get all file download links'
    echo '   var links = [];'
    echo '   document.querySelectorAll("[data-testid=\"download-button\"], a[href*=\"ndownloader\"]").forEach(el => {'
    echo '       if(el.href) links.push(el.href);'
    echo '   });'
    echo '   console.log(links.join("\\n"));'
    echo ""
    echo "4. Copy the output and save to '$URLS_FILE' (one URL per line)"
    exit 1
fi

# Create download directory
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR" || exit 1

# Count total files
TOTAL=$(grep -c . "../$URLS_FILE" 2>/dev/null || echo 0)
CURRENT=0

echo "Starting download of $TOTAL files..."
echo "Download directory: $DOWNLOAD_DIR"
echo "Log file: $LOG_FILE"
echo "============================================"

# Download each URL
while IFS= read -r url || [[ -n "$url" ]]; do
    # Skip empty lines and comments
    [[ -z "$url" || "$url" =~ ^# ]] && continue

    ((CURRENT++))
    echo ""
    echo "[$CURRENT/$TOTAL] Downloading: $url"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Downloading: $url" >> "../$LOG_FILE"

    # wget with:
    # -c : continue partial downloads
    # --content-disposition : use server-provided filename
    # --tries=5 : retry up to 5 times
    # --retry-connrefused : retry on connection refused
    # --waitretry=5 : wait between retries
    # --timeout=60 : connection timeout
    wget -c \
        --content-disposition \
        --tries=5 \
        --retry-connrefused \
        --waitretry=5 \
        --timeout=60 \
        "$url"

    RESULT=$?
    if [[ $RESULT -eq 0 ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - SUCCESS: $url" >> "../$LOG_FILE"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - FAILED (exit code $RESULT): $url" >> "../$LOG_FILE"
        echo "Warning: Download failed for $url"
    fi

    # Small delay between downloads to be nice to the server
    sleep 2

done < "../$URLS_FILE"

echo ""
echo "============================================"
echo "Download complete!"
echo "Files saved in: $DOWNLOAD_DIR"
echo "Check $LOG_FILE for details"
