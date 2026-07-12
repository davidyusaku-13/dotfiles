#!/bin/bash

# Check if user provided a number
if [ -z "$1" ]; then
    echo "Usage: setradius <corner_radius>"
    echo "Example: setradius 15"
    exit 1
fi

RADIUS=$1
echo "Applying corner radius: $RADIUS"

# 1. Update the config file permanently
# We use readlink to find the real file, otherwise sed destroys the Stow symlink!
CONFIG_FILE=$(readlink -f "$HOME/.config/picom/picom.conf")

if [ -f "$CONFIG_FILE" ]; then
    sed -i -E "s/^[[:space:]]*corner-radius[[:space:]]*=[[:space:]]*[0-9]+;/corner-radius = $RADIUS;/" "$CONFIG_FILE"
    echo "Successfully updated picom config."
    
    # 2. Restart picom to apply instantly
    killall -q picom
    # Wait half a second to ensure it releases the window manager hooks
    sleep 0.5
    picom -b
    echo "Picom restarted successfully!"
else
    echo "Error: Could not find picom config file to save changes."
fi
