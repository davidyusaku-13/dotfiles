#!/bin/bash

# Check if user provided a number
if [ -z "$1" ]; then
    echo "Usage: setradius <corner_radius>"
    echo "Example: setradius 15"
    exit 1
fi

RADIUS=$1

if [ "$RADIUS" -gt 0 ]; then
    I3_CONFIG=$(readlink -f "$HOME/.config/i3/config")
    if [ -f "$I3_CONFIG" ]; then
        # Extract current gaps from i3 config
        CURRENT_INNER=$(grep -oP '^[[:space:]]*gaps inner \K[0-9]+' "$I3_CONFIG" | head -1)
        CURRENT_OUTER=$(grep -oP '^[[:space:]]*gaps outer \K[0-9]+' "$I3_CONFIG" | head -1)
        
        # Treat empty extraction as 0
        CURRENT_INNER=${CURRENT_INNER:-0}
        CURRENT_OUTER=${CURRENT_OUTER:-0}
        
        if [ "$CURRENT_INNER" -eq 0 ] || [ "$CURRENT_OUTER" -eq 0 ]; then
            echo "⚠️ Uniformity Rule: You cannot have a corner radius > 0 when gaps are 0!"
            echo "Forcing corner radius to 0."
            RADIUS=0
        fi
    fi
fi

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
