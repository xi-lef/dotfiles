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
cd $DIRECTORY

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

#YOUTUBE_DL_FLAGS=(--download-archive archive.txt -f bestaudio -o '%(id)s %(artist)s - %(track)s.%(ext)s' -x --audio-format mp3 --add-metadata --embed-thumbnail)
YOUTUBE_DL_FLAGS=(--download-archive archive.txt -f bestaudio -o '%(artist)s - %(track)s.%(ext)s' -x --audio-format mp3 --add-metadata --embed-thumbnail)
youtube-dl "${YOUTUBE_DL_FLAGS[@]}" $LINK
exit

# video-id is at the start of downloaded songs.
VIDEO_ID_CHARS="[a-zA-Z0-9_-]"
VIDEO_ID_LENGTH=11
REGEX_BAD_SONG="\.\/$VIDEO_ID_CHARS\{$VIDEO_ID_LENGTH\} NA - NA.mp3"

## rename all correctly named songs to remove video-id at start.
# same pattern as for "bad" above, but negated. the purpose of the grep is to
# not rename songs that have already been renamed before (by a previous
# invocation of this script).
good_songs="$(find . -regextype sed ! -regex "$REGEX_BAD_SONG" | grep -P "$VIDEO_ID_CHARS{$VIDEO_ID_LENGTH} .*? - .*?.mp3")"

echo "$good_songs" |
while read -r file; do
    if [[ ! $file ]]; then
        break
    fi

    new_name="$(printf %s "$file" | cut -d ' ' -f 2-)"
    mv -- "$file" "$new_name"
done

echo

## print bad songs with youtube-title for interactive resolving.
bad_songs=$(find . -regextype sed -regex "$REGEX_BAD_SONG")
if [[ ! $bad_songs ]]; then
    echo "no bad songs :)"
else
    echo "$(echo $bad_songs | grep -o 'mp3' | wc -l) songs could not be named properly, renaming manually..."

    IFS=$'\n'
    for file in $bad_songs; do
        echo
        file=${file:2} # strip './' at the start (from find)
        url=https://www.youtube.com/watch?v=${file:0:$VIDEO_ID_LENGTH}
        title=$(youtube-dl -e "$url" 2> /dev/null)
        title=${title//\//_} # replace all '/'s with '_'s
        if [[ $? == 1 ]]; then
            echo "something went wrong for '$file' ($url), skipping..."
            continue
        fi

        echo "filename: '$file', youtube-title: '$title'"
        echo "please type the new name (without the file extension, empty to use youtube-title):"
        read -r new_name
        if [[ ! $new_name ]]; then
            new_name="$title"
        fi
        mv -- "$file" "$new_name".mp3
    done
    unset IFS
fi

echo

## normalize mp3 volumes.
#collectiongain .
