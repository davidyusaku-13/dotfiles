#!/bin/bash

# Default fallback color (Catppuccin Mocha Base) in case the image isn't a PNG
LOCK_ARGS="-c 1E1E2E"

if [ -f "$HOME/.fehbg" ]; then
    # feh saves the last wallpaper in ~/.fehbg wrapped in single quotes
    # Extract the file path from between those quotes
    IMG=$(grep -oP "'\K[^']+" "$HOME/.fehbg" | head -1)
    
    # Vanilla i3lock ONLY supports .png files. 
    # If we pass a .jpg, it will crash.
    if [ -f "$IMG" ] && [[ "$IMG" == *.png ]]; then
        LOCK_ARGS="-i $IMG"
    fi
fi

# Execute i3lock with the image (or fallback color)
i3lock $LOCK_ARGS --nofork