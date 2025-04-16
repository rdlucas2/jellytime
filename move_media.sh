#!/usr/bin/env bash

###############################################################################
# move_media.sh
#
# Usage: 
#   ./move_media.sh <movie|show> "/path/to/Flow.2024.1080p.WEBRip.10Bit.DDP5.1.x265-Asiimov.mkv"
#
# This script will:
#   1) Parse year from filename (e.g., 2024).
#   2) Parse title from filename (e.g., Flow).
#   3) Create a folder named "Flow (2024)" in either 
#       /mnt/z/jellyfin/Movies    (if movie)
#       /mnt/z/jellyfin/Shows     (if show)
#   4) Move the file into that folder via sudo.
###############################################################################

# --- Safety checks on arguments ----------------------------------------------
if [ $# -lt 2 ]; then
  echo "Usage: $0 [movie|show] <full-path-to-file>"
  exit 1
fi

MEDIA_TYPE="$1"           # "movie" or "show"
FILE_PATH="$2"            # full path to the file
BASEFILE="$(basename "$FILE_PATH")"  # just the file name

# --- Determine destination path based on media type -------------------------
if [ "$MEDIA_TYPE" = "movie" ]; then
  DEST_PARENT="/mnt/z/jellyfin/Movies"
elif [ "$MEDIA_TYPE" = "show" ]; then
  DEST_PARENT="/mnt/z/jellyfin/Shows"
else
  echo "Error: MEDIA_TYPE must be 'movie' or 'show'."
  exit 1
fi

# --- Extract the year from the file name -------------------------------------
# Looks for a 4-digit year like 1990..2029 (adjust your regex if you need more range).
YEAR="$(echo "$BASEFILE" | grep -oE '19[0-9]{2}|20[0-3][0-9]')"

if [ -z "$YEAR" ]; then
  echo "Error: Could not find a 4-digit year in filename '$BASEFILE'."
  exit 1
fi

# --- Extract the title (everything before the year, with dots replaced by spaces) ---
# For example: "Flow.2024.1080p..." => "Flow" once we remove ".2024..."
TITLE="$(echo "$BASEFILE" | sed -E "s/\.$YEAR.*//" | tr '.' ' ')"

# Trim any trailing spaces that might remain
TITLE="$(echo "$TITLE" | xargs)"

# --- Construct the final directory name and move ----------------------------
DEST_DIR="${DEST_PARENT}/${TITLE} (${YEAR})"

# Create directory (including parent dirs if needed)
sudo mkdir -p "$DEST_DIR"

# Move the file
echo "Moving '$FILE_PATH' to '$DEST_DIR'..."
sudo mv "$FILE_PATH" "$DEST_DIR"

echo "Done."

