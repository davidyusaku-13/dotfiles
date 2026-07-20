#!/bin/bash

ACTION=$1
STEP=5
MAX_VOL=150

# Get current volume
CURRENT_VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1) || CURRENT_VOL=0
[ -z "$CURRENT_VOL" ] && CURRENT_VOL=0

if [ "$ACTION" == "up" ]; then
    # Calculate what the new volume would be
    NEW_VOL=$((CURRENT_VOL + STEP))
    
    if [ "$CURRENT_VOL" -ge "$MAX_VOL" ]; then
        # Already at or above max, do nothing or force to max
        pactl set-sink-volume @DEFAULT_SINK@ ${MAX_VOL}%
    elif [ "$NEW_VOL" -gt "$MAX_VOL" ]; then
        # Adding step puts it over the edge, just set exactly to max
        pactl set-sink-volume @DEFAULT_SINK@ ${MAX_VOL}%
    else
        # Normal volume up
        pactl set-sink-volume @DEFAULT_SINK@ +${STEP}%
    fi
elif [ "$ACTION" == "down" ]; then
    # Normal volume down
    pactl set-sink-volume @DEFAULT_SINK@ -${STEP}%
fi
