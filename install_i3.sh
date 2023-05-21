#!/bin/bash

# Script to configure i3 WM on any Debian based distro
# Tested on Debian, Ubuntu and Raspberry Pi OS
# Only installs what's needed for i3, so should be called from other scripts
# It assumes you are logged in as the user who will be using i3

echo "----------------------"
echo "i3 Installation Script"
echo "----------------------"

# Install the i3 window manager and some basic utilities (all of these are referenced in my i3 config file, so need to be installed)

sudo apt install -y i3 i3blocks feh arandr scrot xautolock barrier kitty imagemagick polybar caffeine

# Set up i3. Comment this out if you want to use your own config file or build your config from scratch.

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/config
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/lock.sh
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/kitty.conf
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/polybar_config
mkdir ~/.config/i3
mv config ~/.config/i3/
sudo mv lock.sh /usr/local/bin/
mkdir ~/.config/kitty
mv kitty.conf ~/.config/kitty/
mkdir ~/.config/polybar
mv polybar_config ~/.config/polybar/config

# Set up i3 wallpaper

sudo mkdir /usr/share/wallpaper
# Copy any existing wallpapers into this new directory (delete any you don't like later)
sudo cp -R /usr/share/backgrounds/* /usr/share/wallpaper

# In my i3 config file we switch wallpaper using MOD + Z, but this requires a script
cd $HOME
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/randomise_wallpaper
sudo mv randomise_wallpaper /usr/local/bin/
sudo chmod 755 /usr/local/bin/randomise_wallpaper

echo "------------------------------------------------------------------------"
echo "i3 is now installed. Log out and choose it from your window manager menu"
echo "------------------------------------------------------------------------"
