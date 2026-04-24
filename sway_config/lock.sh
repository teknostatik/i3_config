#!/bin/bash

set -euo pipefail

image="$(mktemp --suffix .png /tmp/swaylock.XXXXXX)"
grim "$image"
convert "$image" -scale 10% -scale 1000% "$image"
swaylock --daemonize --image "$image"