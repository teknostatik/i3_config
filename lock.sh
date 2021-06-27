#!/bin/bash

# Script to generate lock screen image
# Copy to ~/.config/i3/scripts if you're using my i3 config file

img=/tmp/i3lock.png

scrot -o $img
convert $img -scale 10% -scale 1000% $img

i3lock -u -i $img
