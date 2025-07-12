#!/usr/bin/bash

DEFAULT_INTERVAL=1800

if [ $# -lt 1 ] || [ ! -d "$1" ]; then
    printf "Usage:\n\t\e[1m%s\e[0m \e[4mDIRECTORY\e[0m [\e[4mINTERVAL\e[0m]\n" "$0"
    printf "\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every %d seconds if unspecified)." "$DEFAULT_INTERVAL"
    exit 1
fi

export SWWW_TRANSITION=wipe
export SWWW_TRANSITION_ANGLE=75
export SWWW_TRANSITION_FPS="${SWWW_TRANSITION_FPS:-144}"
export SWWW_TRANSITION_STEP="${SWWW_TRANSITION_STEP:-90}"

while true; do
    echo "Interating..."
    find "$1" -type f |
        while read -r img; do
            echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
        done |
        sort -n | cut -d':' -f2- |
        while read -r img; do
            swww img "$img"
            echo "wallpaper changed successfully"
            sleep "$DEFAULT_INTERVAL"
        done
done
