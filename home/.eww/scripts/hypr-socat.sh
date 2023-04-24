#!/usr/bin/env bash

last_window="hypr-socat"
current_workspace="1"
# pid=""

function print_scroll() {
    # if [[ $pid != "" ]]; then
    #     echo $pid
    #     kill -9 $pid
    # fi
    # (echo "$last_window" | zscroll -b "[$current_workspace]" -l 40 -d 0.5) &
    # pid=$!
    echo "[$current_workspace]${last_window:0:40}"
}

function handle() {
    if [[ ${1:0:6} == "active" ]]; then
        if [[ ${1:6:7} == "window>" ]]; then # no windowv2
            last_window=${1#*,}
        fi
        #   elif [[ ${1:0:4} == "move" ]]; then
        #     if [[ ${1:4:7} == "window>" ]]; then # no windowv2
        #       echo "move:${1#*>>}"
        #     else
        #       echo "???"
        #     fi
    elif [[ ${1:0:9} == "workspace" ]]; then
        current_workspace="${1#*>>}"
    else
        echo "$1"
    fi
    print_scroll
}

# tail -f /tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/hyprland.log
socat -U - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
    while read -r line; do handle "$line"; done
