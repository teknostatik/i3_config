# Sway configuration

This directory is a Wayland-oriented replacement for the i3 setup in `i3_config`.

It keeps the existing overall feel where possible:

- `Alt` remains the main modifier.
- `kitty` stays as the terminal.
- The same workspace numbering and most movement bindings are preserved.
- The Dracula-inspired colours are carried across to Sway, Waybar, Mako, and Kitty.
- Existing tray-style applications such as NetworkManager, Blueman, Dropbox, CopyQ, and Caffeine are still launched.

Wayland-native replacements are used where i3 relied on X11-only tools:

- `wofi` replaces `i3-dmenu-desktop`
- `waybar` replaces `polybar`
- `swaylock` and `swayidle` replace the i3 lock / idle flow
- `swaybg` replaces `feh`
- `grim` and `slurp` replace `scrot`
- `wdisplays` replaces `arandr`

## Install

Run:

```bash
./install_sway.sh
```

Then log out and select the Sway session from your display manager.

## Notes

- Many X11 applications will still work through Xwayland.
- Clipboard managers and tray applications vary a bit under Wayland, so if one of the X11 holdovers behaves badly on your machine, that is the first place to swap in a Wayland-native alternative.