#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "------------------------"
echo "Sway Installation Script"
echo "------------------------"

sudo apt update
sudo apt install -y \
    sway \
    swaybg \
    swayidle \
    swaylock \
    waybar \
    wofi \
    grim \
    slurp \
    wl-clipboard \
    wdisplays \
    brightnessctl \
    network-manager-gnome \
    blueman \
    copyq \
    kitty \
    imagemagick \
    mako-notifier \
    pavucontrol \
    playerctl \
    xdg-desktop-portal-wlr \
    policykit-1-gnome \
    lxappearance \
    caffeine

mkdir -p "$HOME/.config/sway"
cp "$SCRIPT_DIR/config" "$HOME/.config/sway/config"

mkdir -p "$HOME/.config/waybar"
cp "$SCRIPT_DIR/waybar_config.jsonc" "$HOME/.config/waybar/config-sway.jsonc"
cp "$SCRIPT_DIR/waybar_style.css" "$HOME/.config/waybar/style-sway.css"

# Backward-compatible defaults for setups still launching plain `waybar`.
cp "$SCRIPT_DIR/waybar_config.jsonc" "$HOME/.config/waybar/config.jsonc"
cp "$SCRIPT_DIR/waybar_style.css" "$HOME/.config/waybar/style.css"

mkdir -p "$HOME/.config/kitty"
cp "$SCRIPT_DIR/kitty.conf" "$HOME/.config/kitty/kitty.conf"

mkdir -p "$HOME/.config/mako"
cp "$SCRIPT_DIR/mako.conf" "$HOME/.config/mako/config"

sudo install -m 755 "$SCRIPT_DIR/lock.sh" /usr/local/bin/sway-lock-blur
sudo install -m 755 "$SCRIPT_DIR/randomise_wallpaper" /usr/local/bin/randomise_wallpaper_wayland
sudo install -m 755 "$SCRIPT_DIR/waybar_launch.sh" /usr/local/bin/waybar-launch
sudo install -m 755 "$SCRIPT_DIR/screenshot_region.sh" /usr/local/bin/sway-screenshot-region
sudo install -m 755 "$SCRIPT_DIR/sway_root_launch.sh" /usr/local/bin/sway-root-launch

sudo mkdir -p /usr/share/wallpaper
sudo cp -Rn /usr/share/backgrounds/. /usr/share/wallpaper/

echo "--------------------------------------------------------------------------------"
echo "Sway is now installed. Log out, choose the Sway session, then log back in." 
echo "--------------------------------------------------------------------------------"