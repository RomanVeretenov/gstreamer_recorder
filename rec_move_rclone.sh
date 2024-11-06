#!/bin/bash

# set -eax

usage() {
    echo Usage: rec_move_rclone.sh files_wildcard rclone_remote
    echo ex: rec_move_rclone.sh "*.mp4" gremote:
}

wildcard=$1
remote=$2

if [[ -z "$wildcard" || -z "$remote" ]]; then
    usage
    exit 1
fi



while true
do
    for filename in $wildcard; do
        # echo rclone -P move $filename $remote
        ffprobe -hide_banner $filename && rclone -P move $filename $remote
    done
    sleep 60
done
