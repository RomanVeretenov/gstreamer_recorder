#!/bin/bash

# File to store PIDs
PID_FILE="/tmp/recording_pids.txt"

# Check if the PID file exists
if [ ! -f "$PID_FILE" ]; then
    echo "PID file not found"
    exit 1
fi

# Read PIDs from the file and kill each process
while read -r pid; do
    if kill -SIGINT "$pid" > /dev/null 2>&1; then
        kill -SIGINT "$pid"
        echo "Stopped process with PID: $pid"
    else
        echo "Process with PID: $pid does not exist."
    fi
done < "$PID_FILE"

# Optionally, clear the PID file after stopping processes
> "$PID_FILE"
echo "All processes stopped. PID file cleared."
