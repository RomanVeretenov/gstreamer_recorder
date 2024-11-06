#!/bin/bash

# File to store PIDs
PID_FILE="/tmp/recording_pids.txt"
# Clear the PID file if it exists
> "$PID_FILE"

rec_stream() {
    url=$1
    file_dest=$2

    codec=
    is_264=$(gst-discoverer-1.0 $url 2>&1 | grep 264)
    if [ -z "$is_264" ]; then
        is_265=$(gst-discoverer-1.0 $url 2>&1 | grep 265)
    fi

    if [[ -z "$is_264" && -z "$is_265" ]]; then
        echo Codec unknown
        exit 1
    else
        if [ -z "$is_264" ]; then
            codec=265
        else
            codec=264
        fi
    fi

    echo Codec is $codec

    gst-launch-1.0 -e \
        rtspsrc location=$url \
        ! rtph${codec}depay ! h${codec}parse ! splitmuxsink location=${file_dest}_%02d.mp4 muxer=mp4mux max-size-time=$((600*1000000000)) &
}

# Get the total number of arguments
num_args=$#

# Check if the number of arguments is even
if (( $num_args % 2 != 0 )); then
    echo "Error: The number of arguments must be even."
    exit 1
fi

# Iterate over arguments in pairs
while [ "$#" -gt 0 ]; do
    arg1="$1" # First argument in the pair
    shift     # Shift to the next argument
    arg2="$1" # Second argument in the pair
    shift     # Shift to the next argument
    rec_stream $arg1 $arg2
    echo $! >> "$PID_FILE"
done

cat "$PID_FILE"
exit
