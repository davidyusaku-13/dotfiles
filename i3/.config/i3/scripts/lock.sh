#!/bin/bash

# Default fallback color (Catppuccin Mocha Base) in case the image isn't a PNG
LOCK_ARGS="-c 1E1E2E"

if [ -f "$HOME/.fehbg" ]; then
    # feh saves the last wallpaper in ~/.fehbg wrapped in single quotes
    # Extract the file path from between those quotes
    IMG=$(grep -oP "'\K[^']+" "$HOME/.fehbg" | head -1)
    
    # Vanilla i3lock ONLY supports .png files. 
    if [ -f "$IMG" ]; then
        if [[ "$IMG" == *.png ]]; then
            LOCK_ARGS="-i $IMG"
        elif command -v convert &> /dev/null; then
            # It's a JPG/WEBP. Convert it, but cache it so locking is instant next time.
            CACHE_IMG="/tmp/i3lock_bg.png"
            if [ ! -f "$CACHE_IMG" ] || [ "$IMG" -nt "$CACHE_IMG" ]; then
                convert "$IMG" "$CACHE_IMG"
            fi
            LOCK_ARGS="-i $CACHE_IMG"
        fi
    fi
fi

# Execute i3lock with the image (or fallback color)
i3lock $LOCK_ARGS --nofork