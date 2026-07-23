#!/bin/bash

chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Lock\n  Logout" | rofi -dmenu -i -theme-str '@import "~/.config/rofi/catppuccin-mocha.rasi"' -p "Power Menu")

case "$chosen" in
    "  Power Off") systemctl poweroff ;;
    "  Restart") systemctl reboot ;;
    "  Suspend") systemctl suspend ;;
    "  Lock") loginctl lock-session ;;
    "  Logout") i3-msg exit ;;
esac