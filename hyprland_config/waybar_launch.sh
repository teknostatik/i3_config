#!/bin/bash

set -euo pipefail

pkill -x waybar >/dev/null 2>&1 || true
nohup waybar >/dev/null 2>&1 &
