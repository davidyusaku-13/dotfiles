#!/bin/bash

# Default fallback color (Catppuccin Mocha Base) in case the image isn't a PNG
LOCK_ARGS="-c 1E1E2E"

if [ -f "$HOME/.fehbg" ]; then
    # Awk reliably grabs the string between the single quotes
    IMG=$(awk -F"'" '/feh/ {print $2}' "$HOME/.fehbg" | head -1)
    
    # Expand tilde (~) to full home path just in case
    IMG="${IMG/#\~/$HOME}"
    
    if [ -n "$IMG" ] && [ -f "$IMG" ]; then
        if [[ "$IMG" == *.png ]]; then
            LOCK_ARGS="-i $IMG"
        elif command -v convert &> /dev/null; then
            # It's a JPG/WEBP. Convert it, but cache it so locking is instant next time.
            # Generate a unique cache filename based on the image path
            IMG_HASH=$(echo -n "$IMG" | md5sum | awk '{print $1}')
            CACHE_IMG="/tmp/i3lock_${IMG_HASH}.png"
            
            if [ ! -f "$CACHE_IMG" ]; then
                convert "$IMG" "$CACHE_IMG"
            fi
            LOCK_ARGS="-i $CACHE_IMG"
        else
            # If convert doesn't exist, send a desktop notification to warn the user
            notify-send "i3lock Fallback" "ImageMagick is missing. Please run: sudo pacman -S imagemagick"
        fi
    else
        notify-send "i3lock Error" "Could not find image at path: $IMG"
    fi
fi

# Execute i3lock with the image (or fallback color)
i3lock $LOCK_ARGS --nofork