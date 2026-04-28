#!/bin/bash

set -euo pipefail

CONFIG_HYPR="$HOME/.config/waybar/config-hyprland.jsonc"
STYLE_HYPR="$HOME/.config/waybar/style-hyprland.css"
CONFIG_FALLBACK="$HOME/.config/waybar/config.jsonc"
STYLE_FALLBACK="$HOME/.config/waybar/style.css"

pkill -x waybar >/dev/null 2>&1 || true

if [ -f "$CONFIG_HYPR" ] && [ -f "$STYLE_HYPR" ]; then
    nohup waybar --config "$CONFIG_HYPR" --style "$STYLE_HYPR" >/dev/null 2>&1 &
elif [ -f "$CONFIG_FALLBACK" ] && [ -f "$STYLE_FALLBACK" ]; then
    nohup waybar --config "$CONFIG_FALLBACK" --style "$STYLE_FALLBACK" >/dev/null 2>&1 &
else
    nohup waybar >/dev/null 2>&1 &
fi
