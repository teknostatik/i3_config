# Sway on NixOS using Home Manager

This directory provides a complete, declarative Sway setup for NixOS laptops using Nix flakes and Home Manager.

## Key features

- **Declarative configuration** — Everything is defined in Nix, no manual file edits needed
- **Home Manager** — User-level configuration, no system-wide changes required
- **Integrated bindings** — All helpers and utilities are set up through Nix expressions
- **Dracula theme** — Consistent colour scheme across Sway, Waybar, Kitty, and Mako
- **Built-in daemons** — Waybar, Mako, and swayidle all managed by Home Manager
- **Wayland-optimized** — Environment variables and portals pre-configured

## Prerequisites

- **NixOS** (tested on 23.11+)
- **Home Manager** (installed via the flake inputs)
- Flakes enabled in your nix config (add `experimental-features = nix-command flakes` to `/etc/nix/nix.conf`)

## Installation

### 1. Copy this directory to your NixOS machine

```bash
git clone https://github.com/teknostatik/i3_config.git
cd i3_config/sway_nixos
```

### 2. Customize `home.nix`

Edit the top of `home.nix`:

```nix
home.username = "andy";  # Your username
home.homeDirectory = "/home/andy";  # Your home path
```

Also update the screen name if needed (default is `eDP-1` for laptops):

```nix
workspace 1 output eDP-1  # Change to your output name (e.g., HDMI-1, DP-1)
```

Find your output name with:

```bash
swaymsg -t get_outputs
```

### 3. Set up wallpapers (optional)

Create a directory for wallpapers:

```bash
mkdir -p ~/.local/share/wallpapers
cp /path/to/your/wallpapers/* ~/.local/share/wallpapers/
```

The Alt+Z keybinding will rotate through wallpapers in this directory.

### 4. Apply the Home Manager configuration

```bash
nix flake update
nix run home-manager/master -- switch --flake .
```

Or, if you prefer to use a pinned version:

```bash
home-manager switch --flake .#sway
```

### 5. Log out and back in, or restart Sway

Press `Alt+Shift+R` to reload Sway, or log out and select Sway as your session at login.

## System-level configuration (optional)

The `configuration.nix.example` file shows recommended system-level settings for a NixOS laptop. If you want Sway to work perfectly, add these to your `/etc/nixos/configuration.nix`:

```nix
# Pipewire for audio
services.pipewire.enable = true;
services.pipewire.pulse.enable = true;

# Polkit for privilege elevation
security.polkit.enable = true;

# XDG portals
xdg.portal.enable = true;
xdg.portal.wlr.enable = true;

# Wayland environment variables
environment.sessionVariables = {
  MOZ_ENABLE_WAYLAND = "1";
  QT_QPA_PLATFORM = "wayland";
};
```

Then rebuild:

```bash
sudo nixos-rebuild switch
```

## File structure

- **flake.nix** — Nix flake entry point; defines inputs and calls Home Manager
- **home.nix** — Home Manager configuration; defines all packages, Sway config, Waybar, Kitty, Mako, and helper scripts
- **configuration.nix.example** — System-level configuration suggestions (copy and adapt to your setup)
- **README.md** — This file

## Keybindings summary

| Binding | Action |
|---------|--------|
| `Alt+Return` | Open terminal (Kitty) |
| `Alt+D` | Application launcher (wofi) |
| `Alt+Q` | Close window |
| `Alt+J/K/L/;` or arrows | Navigate focus |
| `Alt+Shift+J/K/L/;` or arrows | Move window |
| `Alt+H` | Horizontal split |
| `Alt+V` | Vertical split |
| `Alt+F` | Fullscreen |
| `Alt+S/W/E` | Stacking/Tabbed/Split layouts |
| `Alt+Shift+Space` | Toggle floating |
| `Alt+1..9,0` | Switch to workspace |
| `Alt+Shift+1..9,0` | Move window to workspace |
| `Alt+R` | Enter resize mode |
| `Alt+BackSpace` | System menu (lock/suspend/reboot/shutdown) |
| `Super+L` | Lock screen |
| `Print` | Screenshot region (copies to clipboard) |
| `Alt+Z` | Randomize wallpaper |
| `XF86Audio*` | Volume/brightness control |

## Customization

### Change colour scheme

Edit the `colors` section in `home.nix` to use a different palette. The default is Dracula.

### Add/remove packages

Add packages to the `home.packages` list in `home.nix`. For example:

```nix
home.packages = with pkgs; [
  firefox
  vlc
  # ... existing packages ...
];
```

### Modify Sway keybindings

Edit the `keybindings` section under `wayland.windowManager.sway.config` in `home.nix`.

### Adjust Waybar modules

Edit the `programs.waybar.settings` section in `home.nix`.

## Troubleshooting

### Waybar doesn't appear

Make sure `services.mako.enable = true` and `wayland.windowManager.sway.systemd.enable = true` are set in `home.nix`.

### Wallpaper won't load

Create the wallpaper directory and add images:

```bash
mkdir -p ~/.local/share/wallpapers
cp /usr/share/pixmaps/*.png ~/.local/share/wallpapers/
```

### Audio doesn't work

Ensure system-level Pipewire is running:

```bash
systemctl --user status pipewire
systemctl --user status pipewire-pulse
```

If not enabled, add to your `/etc/nixos/configuration.nix`:

```nix
services.pipewire.enable = true;
services.pipewire.pulse.enable = true;
```

### Bluetooth apps won't launch

Ensure polkit is running:

```bash
systemctl --user status polkit-gnome-authentication-agent-1
```

If it's not in the systemd units, add to `home.nix`:

```nix
systemd.user.services.polkit-gnome = {
  Unit.Description = "Polkit GNOME Authentication Agent";
  Install.WantedBy = [ "graphical-session.target" ];
  Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
};
```

## More resources

- [Home Manager documentation](https://nix-community.github.io/home-manager/)
- [Sway documentation](https://github.com/swaywm/sway/wiki)
- [NixOS Wayland wiki](https://nixos.wiki/wiki/Wayland)
