#!/bin/bash

# Catppuccin Mocha Colors (RRGGBBAA format for i3lock-color)
BASE="1e1e2eff"
TEXT="cdd6f4ff"
MAUVE="cba6f7ff"
RED="f38ba8ff"
TRANSPARENT="00000000"

LOCK_ARGS="--color=$BASE"

if [ -f "$HOME/.fehbg" ]; then
    # Awk reliably grabs the string between the single quotes
    IMG=$(awk -F"'" '/feh/ {print $2}' "$HOME/.fehbg" | head -1)
    
    # Expand tilde (~) to full home path just in case
    IMG="${IMG/#\~/$HOME}"
    
    # i3lock-color natively supports JPEGs and scaling!
    if [ -n "$IMG" ] && [ -f "$IMG" ]; then
        LOCK_ARGS="-i $IMG --fill"
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
    --keyhl-color=$MAUVE \
    --bshl-color=$RED \
    --separator-color=$TRANSPARENT \
    --verif-color=$TEXT \
    --wrong-color=$RED \
    --time-color=$TEXT \
    --date-color=$TEXT \
    --time-str="%H:%M" \
    --date-str="%A, %B %d"
