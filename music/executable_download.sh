#!/bin/bash

set -euo pipefail

if [[ ! $1 ]]; then
    echo "Usage: $0 <dir> (<dir> must contain a file called 'link'!)"
    exit 1
fi

DIRECTORY=$1
if [[ ! -d $DIRECTORY ]]; then
    echo "$DIRECTORY is not a directory! exiting..."
    exit 1
fi

# cd so we do not have to prepend $DIRECTORY everywhere.
cd "$DIRECTORY"

LINK_FILE="link"
if [ ! -r $LINK_FILE ]; then
    echo "file $LINK_FILE not found or not readable! exiting..."
    exit 1
fi

read -r LINK < $LINK_FILE

if [[ ! $LINK ]]; then
    echo "no 'link'-file in '$LINK_FILE'! exiting..."
    exit 1
fi

YOUTUBE_DL_FLAGS=(--download-archive archive.txt -f bestaudio -o '%(artist)s - %(track)s.%(ext)s' -x --audio-format mp3 --add-metadata --embed-thumbnail)
youtube-dl "${YOUTUBE_DL_FLAGS[@]}" "$LINK"
