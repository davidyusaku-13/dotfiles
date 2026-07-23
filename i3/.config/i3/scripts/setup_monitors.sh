#!/usr/bin/env bash

# Dynamically assign workspaces to monitors based on connected displays

# Wait for i3 to be ready
sleep 1

readarray -t monitors < <(xrandr --query | grep " connected " | awk '{print $1}')
count=${#monitors[@]}
[ "$count" -lt 2 ] && exit 0

total_ws=10
per_monitor=$((total_ws / count))

for i in "${!monitors[@]}"; do
    [ "$i" -eq 0 ] && continue
    mon="${monitors[$i]}"
    start=$((i * per_monitor + 1))
    end=$((start + per_monitor - 1))
    for ws in $(seq "$start" "$end"); do
        i3-msg "workspace number $ws; move workspace to output \"$mon\"" > /dev/null 2>&1
    done
done
