#!/usr/bin/env bash

BASE="1e1e2eff"
TEXT="cdd6f4ff"
MAUVE="cba6f7ff"
RED="f38ba8ff"
GREEN="a6e3a1ff"
TRANSPARENT="00000000"

# Try to get current wallpaper from nitrogen config, fall back to fehbg, then default
IMG=""
if [ -f "$HOME/.config/nitrogen/bg-saved.cfg" ]; then
    IMG=$(grep '^file=' "$HOME/.config/nitrogen/bg-saved.cfg" | head -1 | cut -d= -f2-)
elif [ -f "$HOME/.fehbg" ]; then
    IMG=$(awk -F"'" '/feh/ {print $2}' "$HOME/.fehbg" | head -1)
    IMG="${IMG/#\~/$HOME}"
fi

# Fallback to background in repository
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
if [ -z "$IMG" ] || [ ! -f "$IMG" ]; then
    if [ -d "$DOTFILES_DIR/backgrounds" ]; then
        IMG=$(find "$DOTFILES_DIR/backgrounds" -type f \( -name '*.jpg' -o -name '*.png' \) | head -1)
    fi
fi

LOCK_ARGS=("--color=$BASE")

if [ -n "$IMG" ] && [ -f "$IMG" ]; then
    LOCK_ARGS=()
    mtime=$(stat -c %Y "$IMG" 2>/dev/null || echo 0)
    CONVERT_CMD="convert"
    command -v magick >/dev/null 2>&1 && CONVERT_CMD="magick"

    while IFS= read -r res; do
        [ -z "$res" ] && continue
        res_hash=$(echo -n "${IMG}_${mtime}_${res}" | md5sum | awk '{print $1}')
        cache="/tmp/i3lock_${res_hash}.png"
        if [ ! -f "$cache" ]; then
            if command -v "$CONVERT_CMD" >/dev/null 2>&1; then
                "$CONVERT_CMD" "$IMG" -resize "${res}^" -gravity center -extent "${res}" "$cache"
            fi
        fi
        [ -f "$cache" ] && LOCK_ARGS+=("-i" "$cache")
    done < <(xrandr | grep '\*' | awk '{print $1}')
    [ ${#LOCK_ARGS[@]} -eq 0 ] && LOCK_ARGS=("--color=$BASE")
fi

exec i3lock "${LOCK_ARGS[@]}" \
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
