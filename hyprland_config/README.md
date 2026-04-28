# Hyprland configuration

This directory is a Wayland-oriented replacement for the i3 setup in the parent directory, targeting Hyprland as the compositor.

It builds on the same foundations as the Sway setup in `sway_config` but uses Hyprland-native syntax and daemons throughout.

## What stays the same

- `Alt` is the main modifier.
- `kitty` is the terminal.
- Workspace numbering 1–20 and all movement/split keybindings are preserved.
- Dracula colour palette carried across to Hyprland border colours, Waybar, Mako, and Kitty.
- Same tray applications: NetworkManager, Blueman, Dropbox, CopyQ, Caffeine.
- Same tools for screenshots (`grim`/`slurp`), display layout (`wdisplays`), and audio (`pactl`).

## Key differences from Sway

| i3/Sway | Hyprland |
|---------|----------|
| Sway config syntax | `hyprland.conf` (ini-like, section-based) |
| `swayidle` | `hypridle` (`~/.config/hypr/hypridle.conf`) |
| `swaybg` + `feh` | `hyprpaper` (`~/.config/hypr/hyprpaper.conf`) |
| `sway/workspaces` Waybar module | `hyprland/workspaces` |
| `sway/mode` Waybar module | `hyprland/submap` |
| Modes (`mode "resize"`) | Submaps (`submap = resize`) |
| `for_window` rules | `windowrulev2` rules |
| Polybar `i3` module | Waybar `hyprland/workspaces` module |
| `picom` compositor | Hyprland has built-in blur/rounding |

## Hyprland layout notes

Hyprland uses a **dwindle** layout by default (configured in `hyprland.conf`). This is a binary-space tiling layout, which is the closest match to i3's default split behaviour. The layout orientation bindings (`Alt+H`, `Alt+V`, `Alt+E`, `Alt+S`, `Alt+W`) map to `layoutmsg` calls that adjust the dwindle orientation.

Hyprland does not have an i3-style stacking or tabbed layout. If you need tab-like behaviour, the master layout or workspace per-application workflows are typical alternatives.

## Lock screen

Two options are provided:

- **`lock.sh`** — uses `grim` to capture a screenshot, pixelates it with ImageMagick, then displays it via `swaylock`. This mirrors the i3 blur-lock behaviour exactly. This is the default used in `hyprland.conf` and `hypridle.conf`.
- **`hyprlock.conf`** — a native `hyprlock` config with a Dracula-styled lock screen (clock + password input). To use it, replace `/usr/local/bin/hypr-lock-blur` calls in `hyprland.conf` and `hypridle.conf` with `hyprlock`.

## Requirements

- Ubuntu 24.04 (Noble) or later.
- Some packages (`hyprlock`, `hypridle`, `hyprpaper`) may not be in the standard Ubuntu repositories. The install script adds the official Hyprland PPA automatically.

## Install

```bash
./install_hyprland.sh
```

Then log out and select the **Hyprland** session from your display manager.

## First boot notes

- Edit `~/.config/hypr/hyprland.conf` and set `kb_layout` to match your keyboard (e.g. `gb`, `de`, `fr`).
- Run `wdisplays` to configure multiple monitors and add `monitor =` lines to `hyprland.conf`.
- X11 applications run under Xwayland and generally work without changes.
