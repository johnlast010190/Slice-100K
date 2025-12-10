#!/usr/bin/env python3
"""
Download Slice-100K dataset from Figshare
https://figshare.com/s/9d084ff84f3822d2bf17

Usage:
    1. First, get the download URLs from Figshare (see instructions below)
    2. Save them to 'urls.txt' (one URL per line)
    3. Run: python download_dataset.py

To get the URLs:
    1. Open https://figshare.com/s/9d084ff84f3822d2bf17 in your browser
    2. Open Developer Tools (F12) -> Console tab
    3. Paste and run:

       // Extract all download links
       fetch(window.location.href)
         .then(r => r.text())
         .then(html => {
           const matches = html.match(/ndownloader\/files\/\d+/g) || [];
           const unique = [...new Set(matches)];
           console.log(unique.map(m => 'https://figshare.com/' + m).join('\\n'));
         });

    4. Copy the URLs and save to 'urls.txt'
"""

import os
import subprocess
import sys
import time
from pathlib import Path


def download_file(url: str, output_dir: Path, retries: int = 5) -> bool:
    """Download a file using wget with resume support."""
    for attempt in range(retries):
        try:
            result = subprocess.run(
                [
                    "wget",
                    "-c",  # Continue partial downloads
                    "--content-disposition",  # Use server filename
                    "--tries=3",
                    "--timeout=60",
                    url,
                ],
                cwd=output_dir,
                capture_output=True,
                text=True,
            )
            if result.returncode == 0:
                return True
            print(f"  Attempt {attempt + 1} failed: {result.stderr[:200]}")
        except Exception as e:
            print(f"  Attempt {attempt + 1} error: {e}")

        if attempt < retries - 1:
            wait_time = 2 ** (attempt + 1)  # Exponential backoff
            print(f"  Retrying in {wait_time}s...")
            time.sleep(wait_time)

    return False


def download_from_urls(urls_file: str = "urls.txt", output_dir: str = "dataset"):
    """Download all files from a URL list."""
    urls_path = Path(urls_file)
    output_path = Path(output_dir)

    if not urls_path.exists():
        print(f"Error: '{urls_file}' not found!")
        print("\nTo create the URL file:")
        print("1. Open https://figshare.com/s/9d084ff84f3822d2bf17 in browser")
        print("2. Open Developer Tools (F12) -> Console")
        print("3. Look at the script header for JavaScript to extract URLs")
        print(f"4. Save the URLs to '{urls_file}' (one per line)")
        return

    # Create output directory
    output_path.mkdir(parents=True, exist_ok=True)

    # Read URLs
    urls = [
        line.strip()
        for line in urls_path.read_text().splitlines()
        if line.strip() and not line.startswith("#")
    ]

    print(f"Found {len(urls)} URLs to download")
    print(f"Output directory: {output_path.absolute()}")
    print("=" * 50)

    successful = 0
    failed = []

    for i, url in enumerate(urls, 1):
        print(f"\n[{i}/{len(urls)}] Downloading: {url}")

        if download_file(url, output_path):
            successful += 1
            print("  ✓ Success")
        else:
            failed.append(url)
            print("  ✗ Failed")

        # Small delay between downloads
        if i < len(urls):
            time.sleep(2)

    print("\n" + "=" * 50)
    print(f"Download complete: {successful}/{len(urls)} successful")

    if failed:
        print(f"\nFailed downloads ({len(failed)}):")
        for url in failed:
            print(f"  - {url}")

        # Save failed URLs for retry
        failed_file = "failed_urls.txt"
        Path(failed_file).write_text("\n".join(failed))
        print(f"\nFailed URLs saved to '{failed_file}'")
        print(f"To retry: python {sys.argv[0]} {failed_file}")


def main():
    urls_file = sys.argv[1] if len(sys.argv) > 1 else "urls.txt"
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "dataset"
    download_from_urls(urls_file, output_dir)


if __name__ == "__main__":
    main()
