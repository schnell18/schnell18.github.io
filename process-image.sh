#!/bin/bash

MARKER="JusResizedMarker=1"

function check {
    CHK_FAILURE=""
    # Report presence of any non-resized JPEG
    IMGS=$(find . -type f -iname "*.jpg" -o -iname "*.jpeg")
    for img in $IMGS; do
        if [[ $img =~ "public" || $img =~ "resources" ]]; then
            continue
        fi

        # fail on first occurrence of non-resized image
        if ! magick identify -format "%c" "$img" | grep -q "$MARKER"; then
            CHK_FAILURE="yes"
            echo "$img not resized!"
        fi
    done
    if [[ $CHK_FAILURE == "yes" ]]; then
        exit 3
    else
        exit 0
    fi
}

function process {
    # Process JPEGs
    find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | while read -r img; do
        if [[ $img =~ "public" || $img =~ "resources" ]]; then
            continue
        fi
        echo "Checking: $img"

        # Skip if already resized
        if magick identify -format "%c" "$img" | grep -q "$MARKER"; then
            echo "  → Already resized. Skipping."
            continue
        fi

        # Check for EXIF metadata
        if magick identify -format "%[EXIF:*]" "$img" | grep -q exif; then
            echo "  → EXIF found. Resizing, stripping, and tagging..."
            magick "$img" -resize 50% -strip -set comment "$MARKER" "$img"
        else
            echo "  → No EXIF. Resizing and tagging..."
            magick "$img" -resize 50% -set comment "$MARKER" "$img"
        fi
    done
}

# Ensure ImageMagick is installed
if ! command -v magick >/dev/null 2>&1; then
    echo >&2 "ImageMagick (magick) is required but not installed."
    exit 1
fi

ACTION=${1:-"process"}

if [[ $ACTION == "check" ]]; then
    check
else
    process
fi

