#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "-----------------------------"
echo "Hyprland Installation Script"
echo "-----------------------------"
echo ""
echo "NOTE: Hyprland requires Ubuntu 24.04 (Noble) or later."
echo "      Some packages (hyprlock, hypridle, hyprpaper) may need the"
echo "      official Hyprland PPA: https://github.com/hyprwm/Hyprland"
echo ""

# Add Hyprland PPA if not already present
if ! grep -r "hyprwm" /etc/apt/sources.list.d/ >/dev/null 2>&1; then
    echo "Adding Hyprland PPA..."
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:hyprwm/hyprland
fi

sudo apt update
sudo apt install -y \
    hyprland \
    hyprlock \
    hypridle \
    hyprpaper \
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
    xdg-desktop-portal-hyprland \
    policykit-1-gnome \
    lxappearance \
    caffeine

# Set up Hyprland config
mkdir -p "$HOME/.config/hypr"
cp "$SCRIPT_DIR/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
cp "$SCRIPT_DIR/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
cp "$SCRIPT_DIR/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
cp "$SCRIPT_DIR/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"

# Set up Waybar
mkdir -p "$HOME/.config/waybar"
cp "$SCRIPT_DIR/waybar_config.jsonc" "$HOME/.config/waybar/config.jsonc"
cp "$SCRIPT_DIR/waybar_style.css" "$HOME/.config/waybar/style.css"

# Set up Kitty
mkdir -p "$HOME/.config/kitty"
cp "$SCRIPT_DIR/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Set up Mako notifications
mkdir -p "$HOME/.config/mako"
cp "$SCRIPT_DIR/mako.conf" "$HOME/.config/mako/config"

# Install helper scripts
sudo install -m 755 "$SCRIPT_DIR/lock.sh" /usr/local/bin/hypr-lock-blur
sudo install -m 755 "$SCRIPT_DIR/randomise_wallpaper" /usr/local/bin/randomise_wallpaper_hypr
sudo install -m 755 "$SCRIPT_DIR/waybar_launch.sh" /usr/local/bin/waybar-launch-hypr
sudo install -m 755 "$SCRIPT_DIR/screenshot_region.sh" /usr/local/bin/hypr-screenshot-region

# Set up wallpaper directory
sudo mkdir -p /usr/share/wallpaper
sudo cp -Rn /usr/share/backgrounds/. /usr/share/wallpaper/

# Write a default wallpaper path into hyprpaper.conf
DEFAULT_WALL="$(find /usr/share/wallpaper -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) 2>/dev/null | head -1 || true)"
if [ -n "$DEFAULT_WALL" ]; then
    sed -i "s|__DEFAULT_WALLPAPER__|$DEFAULT_WALL|g" "$HOME/.config/hypr/hyprpaper.conf"
else
    echo "WARNING: No wallpaper images found in /usr/share/wallpaper."
    echo "         Edit ~/.config/hypr/hyprpaper.conf to set a valid path."
fi

echo "------------------------------------------------------------------------------------"
echo "Hyprland is now installed. Log out, choose the Hyprland session, then log back in."
echo "------------------------------------------------------------------------------------"
