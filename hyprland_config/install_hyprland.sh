#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(mktemp -d /tmp/hyprland-build.XXXXXX)"

echo "-----------------------------"
echo "Hyprland Installation Script"
echo "-----------------------------"
echo ""
echo "NOTE: Hyprland requires Ubuntu 24.04 (Noble) or later."
echo "      This script builds Hyprland, hyprlock, hypridle, and hyprpaper"
echo "      from source using the official hyprwm repositories."
echo ""

# ---------------------------------------------------------------------------
# 1. Runtime applications (available in standard Ubuntu repos)
# ---------------------------------------------------------------------------
sudo apt update
sudo apt install -y \
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

# ---------------------------------------------------------------------------
# 2. Build dependencies for Hyprland and the hyprwm ecosystem
# ---------------------------------------------------------------------------
sudo apt install -y \
    build-essential \
    cmake \
    meson \
    ninja-build \
    pkg-config \
    git \
    libwayland-dev \
    libwayland-server0 \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libpixman-1-dev \
    libinput-dev \
    libudev-dev \
    libseat-dev \
    libxcb-dri3-dev \
    libxcb-present-dev \
    libxcb-composite0-dev \
    libxcb-render-util0-dev \
    libxcb-xfixes0-dev \
    libxcb-icccm4-dev \
    libxcb-ewmh-dev \
    libxcb-res0-dev \
    libxcb-xinput-dev \
    libxcb1-dev \
    libx11-xcb-dev \
    libxcb-util0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libx11-dev \
    libxcb-xkb-dev \
    xwayland \
    libgbm-dev \
    libdrm-dev \
    libvulkan-dev \
    libvulkan-volk-dev \
    libvkfft-dev \
    glslang-tools \
    libglvnd-dev \
    libegl-dev \
    libgles2-mesa-dev \
    libpango1.0-dev \
    libcairo2-dev \
    libgdk-pixbuf-2.0-dev \
    librsvg2-dev \
    libsystemd-dev \
    libpam0g-dev \
    libmagic-dev \
    libtomlplusplus-dev \
    libudis86-dev \
    libhyprlang-dev \
    libhyprutils-dev \
    hyprwayland-scanner \
    wayland-protocols \
    wayland-scanner++ \
    libcurl4-openssl-dev \
    libglib2.0-dev

# ---------------------------------------------------------------------------
# 3. Build and install each hyprwm component from source
# ---------------------------------------------------------------------------

build_cmake() {
    local repo="$1"
    local name="$2"
    echo ""
    echo ">>> Building $name from source..."
    git clone --depth=1 --recurse-submodules "https://github.com/hyprwm/$repo.git" "$BUILD_DIR/$name"
    cmake -S "$BUILD_DIR/$name" -B "$BUILD_DIR/$name/build" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
    cmake --build "$BUILD_DIR/$name/build" --parallel "$(nproc)"
    sudo cmake --install "$BUILD_DIR/$name/build"
}

build_meson() {
    local repo="$1"
    local name="$2"
    echo ""
    echo ">>> Building $name from source..."
    git clone --depth=1 --recurse-submodules "https://github.com/hyprwm/$repo.git" "$BUILD_DIR/$name"
    meson setup "$BUILD_DIR/$name/build" "$BUILD_DIR/$name" \
        --prefix=/usr \
        --buildtype=release
    ninja -C "$BUILD_DIR/$name/build"
    sudo ninja -C "$BUILD_DIR/$name/build" install
}

# Build order matters: Hyprland must come first, then the utilities.
build_cmake Hyprland   hyprland
build_cmake hyprpaper  hyprpaper
build_cmake hypridle   hypridle
build_cmake hyprlock   hyprlock

# Update the dynamic linker cache in case libraries were installed
sudo ldconfig

echo ""
echo ">>> Cleaning up build directory $BUILD_DIR"
rm -rf "$BUILD_DIR"

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
