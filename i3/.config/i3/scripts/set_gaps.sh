#!/bin/bash

# Check if user provided a number
if [ -z "$1" ]; then
    echo "Usage: setgaps <inner_gap_size>"
    echo "Example: setgaps 20"
    exit 1
fi

INNER=$1
# Bash handles division natively (it automatically rounds down if it's an odd number)
OUTER=$((INNER / 2))

echo "Applying gaps: Inner = $INNER, Outer = $OUTER"

# 1. Update the live i3 session instantly (no reload required)
i3-msg "gaps inner all set $INNER" > /dev/null
i3-msg "gaps outer all set $OUTER" > /dev/null

# 1.5 Enforce Uniformity Rule: If gaps are 0, force corner radius to 0
if [ "$INNER" -eq 0 ]; then
    echo "⚠️ Uniformity Rule: Gaps are 0, automatically disabling rounded corners..."
    "$(dirname "$0")/set_radius.sh" 0
fi

# 2. Update the config file so the change survives a reboot
# We use readlink to find the real file, otherwise sed destroys the Stow symlink!
CONFIG_FILE=$(readlink -f "$HOME/.config/i3/config")

if [ -f "$CONFIG_FILE" ]; then
    sed -i -E "s/^[[:space:]]*gaps inner [0-9]+/gaps inner $INNER/" "$CONFIG_FILE"
    sed -i -E "s/^[[:space:]]*gaps outer [0-9]+/gaps outer $OUTER/" "$CONFIG_FILE"
    echo "Successfully updated i3 config."
else
    echo "Error: Could not find i3 config file to save changes permanently."
fi
