#!/bin/bash
# Download script for Slice-100K dataset from Figshare
# https://figshare.com/s/9d084ff84f3822d2bf17

# Create download directory
DOWNLOAD_DIR="./dataset"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# ============================================================================
# OPTION 1: If you have the ndownloader file IDs
# ============================================================================
# To get the file IDs:
# 1. Go to https://figshare.com/s/9d084ff84f3822d2bf17 in your browser
# 2. Open Developer Tools (F12) -> Network tab
# 3. Click on each download button and look for URLs containing "ndownloader"
# 4. Or right-click the download button and "Copy link address"
# The URL format is: https://figshare.com/ndownloader/files/XXXXXX
#
# Once you have the file IDs, add them to this array:
# FILE_IDS=(
#     "12345678"
#     "12345679"
#     # ... add all 63 file IDs here
# )
#
# for id in "${FILE_IDS[@]}"; do
#     echo "Downloading file ID: $id"
#     wget -c --content-disposition "https://figshare.com/ndownloader/files/$id"
#     sleep 1  # Be nice to the server
# done

# ============================================================================
# OPTION 2: Download all from article (if available)
# ============================================================================
# Try downloading the entire article bundle:
# wget -c --content-disposition "https://ndownloader.figshare.com/articles/9d084ff84f3822d2bf17"

# ============================================================================
# OPTION 3: If files are numbered sequentially (e.g., part_01.zip to part_63.zip)
# ============================================================================
# Uncomment and adjust the pattern based on actual file naming:
#
# for i in $(seq -w 1 63); do
#     FILENAME="Slice-100K_part_${i}.zip"
#     echo "Downloading: $FILENAME"
#     wget -c --content-disposition "https://figshare.com/ndownloader/files/XXXXXX" -O "$FILENAME"
#     sleep 1
# done

# ============================================================================
# OPTION 4: Download from a URL list file
# ============================================================================
# If you create a file called 'urls.txt' with one download URL per line:
#
# while IFS= read -r url; do
#     echo "Downloading: $url"
#     wget -c --content-disposition "$url"
#     sleep 1
# done < urls.txt

echo "============================================"
echo "INSTRUCTIONS:"
echo "============================================"
echo ""
echo "To download the Slice-100K dataset, you need to get the download URLs first."
echo ""
echo "Method 1 - Browser Console (Recommended):"
echo "  1. Open https://figshare.com/s/9d084ff84f3822d2bf17 in your browser"
echo "  2. Press F12 to open Developer Tools"
echo "  3. Go to the Console tab and paste this JavaScript:"
echo ""
echo '     document.querySelectorAll("a[href*=ndownloader]").forEach(a => console.log(a.href));'
echo ""
echo "  4. Copy the URLs and save them to a file called 'urls.txt'"
echo "  5. Then run: ./download_from_urls.sh"
echo ""
echo "Method 2 - Manual:"
echo "  1. Right-click each download button on the Figshare page"
echo "  2. Select 'Copy link address'"
echo "  3. Save all URLs to 'urls.txt' (one per line)"
echo "  4. Then run: ./download_from_urls.sh"
echo ""
