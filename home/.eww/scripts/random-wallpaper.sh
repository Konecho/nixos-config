#!/usr/bin/env bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

# if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
# 	echo "Usage:
# 	$0 <dir containg images>"
# 	exit 1
# fi

# Edit bellow to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2
export XDG_CACHE_HOME="/home/mei/.cache"
img_path="/home/mei/media/photos/pokemon-wallpapers/pokemon"

# This controls (in seconds) when to switch to the next image
# INTERVAL=300

find "$img_path" |
    while read -r img; do
        echo "$((RANDOM % 1000)):$img"
    done |
    sort -n | cut -d':' -f2- |
    if read -r img; then
        swww img "$img"
        echo "$img"
    fi
