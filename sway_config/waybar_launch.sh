#!/bin/bash

set -euo pipefail

CONFIG_SWAY="$HOME/.config/waybar/config-sway.jsonc"
STYLE_SWAY="$HOME/.config/waybar/style-sway.css"
CONFIG_FALLBACK="$HOME/.config/waybar/config.jsonc"
STYLE_FALLBACK="$HOME/.config/waybar/style.css"

pkill -x waybar >/dev/null 2>&1 || true

if [ -f "$CONFIG_SWAY" ] && [ -f "$STYLE_SWAY" ]; then
    nohup waybar --config "$CONFIG_SWAY" --style "$STYLE_SWAY" >/dev/null 2>&1 &
elif [ -f "$CONFIG_FALLBACK" ] && [ -f "$STYLE_FALLBACK" ]; then
    nohup waybar --config "$CONFIG_FALLBACK" --style "$STYLE_FALLBACK" >/dev/null 2>&1 &
else
    nohup waybar >/dev/null 2>&1 &
fi