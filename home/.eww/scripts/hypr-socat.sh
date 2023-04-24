#!/usr/bin/env bash

last_window="hypr-socat"

function print_scroll() {
    echo "$last_window" | zscroll -l 40 -d 0.1
}

function handle() {
    if [[ ${1:0:6} == "active" ]]; then
        if [[ ${1:6:7} == "window>" ]]; then # no windowv2
            last_window=${1#*,}
            print_scroll
        fi
        #   elif [[ ${1:0:4} == "move" ]]; then
        #     if [[ ${1:4:7} == "window>" ]]; then # no windowv2
        #       echo "move:${1#*>>}"
        #     else
        #       echo "???"
        #     fi
    elif [[ ${1:0:9} == "workspace" ]]; then
        echo "workspace:${1#*>>}"
        sleep 1s
        print_scroll
    else
        echo "$1"
        sleep 1s
        print_scroll
    fi
}

# tail -f /tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/hyprland.log
socat -U - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
    while read -r line; do handle "$line"; done
