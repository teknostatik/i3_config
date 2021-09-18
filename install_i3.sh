#!/bin/bash

# Script to configure i3 WM on any Debian based distro
# Tested on Debian, Ubuntu and Raspberry Pi OS
# Only installs what's needed for i3, so should be called from other scripts
# It assumes you are logged in as the user who will be using i3

echo "----------------------------------------"
echo "i3 Installation Script - v0.1, July 2021"
echo "----------------------------------------"

# Install the i3 window manager and some basic utilities (all of these are referenced in my i3 config file, so need to be installed)

sudo apt install -y i3 i3blocks feh arandr scrot xautolock barrier kitty imagemagick
# Uncomment the following for Ubuntu
# sudo add-apt-repository ppa:agornostal/ulauncher -y
# sudo apt install -y ulauncher

# Set up i3. Comment this out if you want to use your own config file or build your config from scratch.

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/config
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/lock.sh
mkdir .config/i3
mv config ~/.config/i3/
sudo mv lock.sh /usr/local/bin/

# Set up i3 wallpaper
# These are downloaded from various places. Will try and find credits at some point.

sudo mkdir /usr/share/wallpaper
# Copy any existing wallpapers into this new directory (delete any you don't like later)
sudo cp -R /usr/share/backgrounds/* /usr/share/wallpaper
# But there are also some different backgrounds I like to use
cd /usr/share/wallpaper
sudo wget https://www.dropbox.com/s/65qlzytfq8c2thu/1920x1080.jpg
sudo wget https://www.dropbox.com/s/xtb4ybjwywzj5f3/3840x2160.png
sudo wget https://www.dropbox.com/s/f2rkmbv13c8t769/1920x1080-dark-linux.png
sudo wget https://www.dropbox.com/s/tc8ejnibiat49t6/5120x2880.png
sudo wget https://www.dropbox.com/s/uuh3exp1shb0h5o/IMG_8585-photivo-1-edit-crop-2160p.jpg
sudo wget https://www.dropbox.com/s/idk05cia43lj5qb/rocket.png
# In my i3 config file we switch wallpaper using MOD + Z, but this requires a script
cd $HOME
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/randomise_wallpaper
sudo mv randomise_wallpaper /usr/local/bin/
sudo chmod 755 /usr/local/bin/randomise_wallpaper

echo "------------------------------------------------------------------------"
echo "i3 is now installed. Log out and choose it from your window manager menu"
echo "------------------------------------------------------------------------"
