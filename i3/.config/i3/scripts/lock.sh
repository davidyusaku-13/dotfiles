#!/bin/bash

# Catppuccin Mocha Colors (RRGGBBAA format for i3lock-color)
BASE="1e1e2eff"
TEXT="cdd6f4ff"
MAUVE="cba6f7ff"
RED="f38ba8ff"
GREEN="a6e3a1ff"
TRANSPARENT="00000000"

LOCK_ARGS="--color=$BASE"

if [ -f "$HOME/.fehbg" ]; then
    # Awk reliably grabs the string between the single quotes
    IMG=$(awk -F"'" '/feh/ {print $2}' "$HOME/.fehbg" | head -1)
    
    # Expand tilde (~) to full home path just in case
    IMG="${IMG/#\~/$HOME}"
    
    if [ -n "$IMG" ] && [ -f "$IMG" ]; then
        # Fetch current screen resolution (fallback to 1920x1080 if it fails)
        RES=$(xrandr | grep '\*' | awk '{print $1}' | head -n 1)
        RES=${RES:-1920x1080}
        
        # Hash the image path + resolution to create a unique cache file
        IMG_HASH=$(echo -n "$IMG$RES" | md5sum | awk '{print $1}')
        CACHE_IMG="/tmp/i3lock_${IMG_HASH}.png"
        
        # If cache doesn't exist, use ImageMagick to perfectly scale/crop it once
        if [ ! -f "$CACHE_IMG" ]; then
            convert "$IMG" -resize "${RES}^" -gravity center -extent "${RES}" "$CACHE_IMG"
        fi
        
        LOCK_ARGS="-i $CACHE_IMG"
    fi
fi

# Execute i3lock-color with the image and Catppuccin styling
i3lock $LOCK_ARGS \
    --nofork \
    --ignore-empty-password \
    --indicator \
    --clock \
    --radius=120 \
    --ring-width=8 \
    --inside-color=$TRANSPARENT \
    --ring-color=$MAUVE \
    --insidever-color=$TRANSPARENT \
    --ringver-color=$TEXT \
    --insidewrong-color=$TRANSPARENT \
    --ringwrong-color=$RED \
    --line-color=$TRANSPARENT \
    --keyhl-color=$GREEN \
    --bshl-color=$RED \
    --separator-color=$TRANSPARENT \
    --verif-color=$TEXT \
    --wrong-color=$RED \
    --time-color=$TEXT \
    --date-color=$TEXT \
    --time-str="%H:%M" \
    --date-str="%A, %B %d"
