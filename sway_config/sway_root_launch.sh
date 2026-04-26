#!/bin/bash

set -euo pipefail

# Launch GUI commands with root privileges in a Sway session.
# - If arguments are given, they are used as the command.
# - If no arguments are given, prompt via wofi.

if [[ $# -gt 0 ]]; then
    cmd="$*"
else
    if ! command -v wofi >/dev/null 2>&1; then
        notify-send "Root launcher" "wofi is not installed and no command was provided."
        exit 1
    fi

    cmd="$(printf '' | wofi --dmenu --prompt 'Run as root (pkexec)')"
fi

if [[ -z "${cmd}" ]]; then
    exit 0
fi

if command -v pkexec >/dev/null 2>&1; then
    exec pkexec /usr/bin/env \
        WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
        XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-}" \
        DISPLAY="${DISPLAY:-}" \
        XAUTHORITY="${XAUTHORITY:-}" \
        DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-}" \
        HOME="${HOME}" \
        /bin/sh -lc "${cmd}"
fi

if command -v sudo >/dev/null 2>&1; then
    if [[ -z "${SUDO_ASKPASS:-}" ]]; then
        for askpass_bin in /usr/bin/ssh-askpass /usr/bin/ksshaskpass /usr/lib/ssh/ssh-askpass; do
            if [[ -x "${askpass_bin}" ]]; then
                export SUDO_ASKPASS="${askpass_bin}"
                break
            fi
        done
    fi

    if [[ -n "${SUDO_ASKPASS:-}" ]]; then
        exec sudo -A /bin/sh -lc "${cmd}"
    fi
fi

notify-send "Root launcher" "No working authentication method found (pkexec/sudo -A)."
exit 1
