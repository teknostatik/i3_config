#!/bin/bash

set -euo pipefail

output_dir="$HOME/Pictures/Screenshots"
timestamp="$(date +%Y-%m-%d-%H%M%S)"
target="$output_dir/screenshot-$timestamp.png"

mkdir -p "$output_dir"
grim -g "$(slurp)" "$target"
wl-copy < "$target"