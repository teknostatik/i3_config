{ config, pkgs, lib, ... }:

{
  home.username = "andy";  # CHANGE THIS to your username
  home.homeDirectory = "/home/andy";  # CHANGE THIS if different
  home.stateVersion = "23.11";

  # ---------------------------------------------------------------------------
  # Packages
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    # Window manager and utilities
    sway
    swaybg
    swayidle
    swaylock
    waybar
    wofi
    wl-clipboard
    wdisplays

    # Applications
    kitty
    firefox
    pavucontrol
    blueman

    # Tools
    grim
    slurp
    brightnessctl
    imagemagick
    playerctl
    copyq

    # Notifications
    mako

    # Tray apps
    network-manager-applet
    caffeine
  ];

  # ---------------------------------------------------------------------------
  # Sway configuration
  # ---------------------------------------------------------------------------
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;
    systemd.enable = true;

    config = let
      mod = "Mod1";
      term = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      lock_cmd = "${pkgs.swaylock}/bin/swaylock -u -c 282a36";
      wallpaper_cmd = "${config.home.homeDirectory}/.local/bin/randomise_wallpaper_nixos";
    in {
      modifier = mod;
      terminal = term;

      fonts = {
        names = [ "monospace" ];
        size = 8.0;
      };

      output."*" = {
        bg = "#282a36 solid_color";
      };

      startup = [
        # DBus environment
        {
          command = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway";
          always = true;
        }
        # Waybar
        {
          command = "${pkgs.waybar}/bin/waybar";
          always = true;
        }
        # Wallpaper
        { command = wallpaper_cmd; }
        # System tray and utilities
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; }
        { command = "${pkgs.blueman}/bin/blueman-applet"; }
        { command = "${pkgs.copyq}/bin/copyq"; }
        { command = "${pkgs.caffeine}/bin/caffeine-indicator"; }
        { command = "${pkgs.mako}/bin/mako"; }
        # Polkit
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        # Idle/lock daemon
        {
          command = ''
            ${pkgs.swayidle}/bin/swayidle -w \
              timeout 900 '${lock_cmd}' \
              timeout 1200 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
              before-sleep '${lock_cmd}'
          '';
        }
      ];

      # Keybindings
      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${term}";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec ${menu}";
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        "${mod}+h" = "split h";
        "${mod}+v" = "split v";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";
        "${mod}+r" = "mode resize";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "Mod4+l" = "exec ${lock_cmd}";
        "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${mod}+z" = "exec ${wallpaper_cmd}";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
        "${mod}+BackSpace" = "mode system";
      };

      modes = {
        resize = {
          j = "resize shrink width 10 px or 10 ppt";
          k = "resize grow height 10 px or 10 ppt";
          l = "resize shrink height 10 px or 10 ppt";
          semicolon = "resize grow width 10 px or 10 ppt";
          Left = "resize shrink width 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          Return = "mode default";
          Escape = "mode default";
          "${mod}+r" = "mode default";
        };

        system = {
          l = "exec ${lock_cmd}, mode default";
          e = "exec swaymsg exit, mode default";
          s = "exec ${lock_cmd} && systemctl suspend, mode default";
          h = "exec ${lock_cmd} && systemctl hibernate, mode default";
          r = "exec systemctl reboot, mode default";
          "Ctrl+s" = "exec systemctl poweroff -i, mode default";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
          position = "bottom";
          hiddenState = "hide";
          mode = "dock";
        }
      ];

      window = {
        border = 2;
      };

      floating = {
        border = 2;
      };

      colors = {
        focused = {
          border = "#6272A4";
          background = "#6272A4";
          text = "#F8F8F2";
          indicator = "#6272A4";
          childBorder = "#6272A4";
        };
        focusedInactive = {
          border = "#44475A";
          background = "#44475A";
          text = "#F8F8F2";
          indicator = "#44475A";
          childBorder = "#44475A";
        };
        unfocused = {
          border = "#282A36";
          background = "#282A36";
          text = "#BFBFBF";
          indicator = "#282A36";
          childBorder = "#282A36";
        };
        urgent = {
          border = "#44475A";
          background = "#FF5555";
          text = "#F8F8F2";
          indicator = "#FF5555";
          childBorder = "#FF5555";
        };
        placeholder = {
          border = "#282A36";
          background = "#282A36";
          text = "#F8F8F2";
          indicator = "#282A36";
          childBorder = "#282A36";
        };
        background = "#F8F8F2";
      };

      workspaceAutoBackAndForth = true;
    };

    extraConfig = ''
      # Workspace definitions
      workspace 1 output eDP-1
      workspace 2 output eDP-1
      workspace 3 output eDP-1
      workspace 4 output eDP-1
      workspace 5 output eDP-1
      workspace 6 output eDP-1
      workspace 7 output eDP-1
      workspace 8 output eDP-1
      workspace 9 output eDP-1
      workspace 10 output eDP-1

      # Floating window rules
      for_window [app_id="pavucontrol"] floating enable
      for_window [app_id="wdisplays"] floating enable
      for_window [class="Gimp"] floating enable
      for_window [class="zoom"] floating enable
      for_window [title="Microsoft Teams Notification"] floating enable
      for_window [title="About Mozilla Firefox"] floating enable
    '';
  };

  # ---------------------------------------------------------------------------
  # Waybar
  # ---------------------------------------------------------------------------
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "bottom";
        height = 28;
        spacing = 8;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "tray" "pulseaudio" "cpu" "memory" "network" "battery" "clock" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{name}";
        };

        "sway/mode" = {
          format = "<span style='italic'>{}</span>";
        };

        "sway/window" = {
          max-length = 80;
          separate-outputs = true;
        };

        "tray" = {
          spacing = 10;
        };

        "pulseaudio" = {
          format = "VOL {volume}% {icon}";
          format-muted = "VOL muted";
          format-icons.default = [ "" "" "" ];
          scroll-step = 5;
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "cpu" = {
          interval = 5;
          format = "CPU {usage}%";
        };

        "memory" = {
          interval = 10;
          format = "MEM {}%";
        };

        "network" = {
          interval = 5;
          format-wifi = "{essid} {signalStrength}%";
          format-ethernet = "{ipaddr}";
          format-linked = "{ifname}";
          format-disconnected = "offline";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        "battery" = {
          interval = 30;
          states = {
            warning = 25;
            critical = 10;
          };
          format = "BAT {capacity}%";
          format-charging = "BAT {capacity}% +";
          tooltip = false;
        };

        "clock" = {
          interval = 1;
          format = "{:%Y-%m-%d %H:%M:%S}";
        };
      }
    ];

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: monospace;
        font-size: 11px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(40, 42, 54, 0.92);
        color: #f8f8f2;
      }

      tooltip {
        background: #282a36;
        border: 1px solid #6272a4;
      }

      #workspaces {
        margin: 4px 0 4px 6px;
      }

      #workspaces button {
        padding: 0 8px;
        margin-right: 4px;
        color: #f8f8f2;
        background: #44475a;
      }

      #workspaces button.focused {
        background: #6272a4;
      }

      #workspaces button.urgent {
        background: #ff5555;
      }

      #mode,
      #window,
      #tray,
      #pulseaudio,
      #cpu,
      #memory,
      #network,
      #battery,
      #clock {
        margin: 4px 6px;
        padding: 0 10px;
        background: #44475a;
        color: #f8f8f2;
      }

      #mode {
        background: #ffb86c;
        color: #282a36;
      }

      #battery.warning {
        background: #f1fa8c;
        color: #282a36;
      }

      #battery.critical {
        background: #ff5555;
      }

      #pulseaudio.muted,
      #network.disconnected {
        background: #6272a4;
      }
    '';
  };

  # ---------------------------------------------------------------------------
  # Kitty terminal
  # ---------------------------------------------------------------------------
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    font.name = "monospace";
    font.size = 9;
    settings = {
      hide_window_decorations = "no";
      background_opacity = "0.8";
      foreground = "#f8f8f2";
      background = "#282a36";
      selection_foreground = "#ffffff";
      selection_background = "#44475a";
      url_color = "#8be9fd";
      cursor = "#f8f8f2";
      cursor_text_color = "background";
      active_tab_foreground = "#282a36";
      active_tab_background = "#f8f8f2";
      inactive_tab_foreground = "#282a36";
      inactive_tab_background = "#6272a4";
      mark1_foreground = "#282a36";
      mark1_background = "#ff5555";
      active_border_color = "#f8f8f2";
      inactive_border_color = "#6272a4";
      enabled_layouts = "tall, stack, grid";
      wayland_titlebar_color = "background";
    };
    colors = {
      color0 = "#21222c";
      color8 = "#6272a4";
      color1 = "#ff5555";
      color9 = "#ff6e6e";
      color2 = "#50fa7b";
      color10 = "#69ff94";
      color3 = "#f1fa8c";
      color11 = "#ffffa5";
      color4 = "#bd93f9";
      color12 = "#d6acff";
      color5 = "#ff79c6";
      color13 = "#ff92df";
      color6 = "#8be9fd";
      color14 = "#a4ffff";
      color7 = "#f8f8f2";
      color15 = "#ffffff";
    };
  };

  # ---------------------------------------------------------------------------
  # Mako notifications
  # ---------------------------------------------------------------------------
  services.mako = {
    enable = true;
    font = "monospace 9";
    backgroundColor = "#282a36";
    textColor = "#f8f8f2";
    borderColor = "#6272a4";
    borderSize = 2;
    borderRadius = 5;
    padding = "10";
    defaultTimeout = 7000;
    ignoreTimeout = true;
    layer = "overlay";

    extraConfig = ''
      [urgency=high]
      border-color=#ff5555
    '';
  };

  # ---------------------------------------------------------------------------
  # Helper scripts
  # ---------------------------------------------------------------------------
  home.file.".local/bin/randomise_wallpaper_nixos" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail
      
      wallpaper_dir="''${HOME}/.local/share/wallpapers"
      if [ ! -d "$wallpaper_dir" ]; then
        echo "Wallpaper directory $wallpaper_dir does not exist" >&2
        exit 1
      fi
      
      wallpaper="$(find "$wallpaper_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)"
      
      if [ -z "$wallpaper" ]; then
        echo "No wallpapers found in $wallpaper_dir" >&2
        exit 1
      fi
      
      ${pkgs.swaybg}/bin/swaybg -i "$wallpaper" -m fill &
    '';
  };

  home.file.".local/bin/lock_screen" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail
      
      image="$(mktemp --suffix .png /tmp/sway-lock.XXXXXX)"
      ${pkgs.grim}/bin/grim "$image"
      ${pkgs.imagemagick}/bin/convert "$image" -scale 10% -scale 1000% "$image"
      ${pkgs.swaylock}/bin/swaylock -u -i "$image"
    '';
  };

  # ---------------------------------------------------------------------------
  # XDG Directories
  # ---------------------------------------------------------------------------
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "\${HOME}/Desktop";
      documents = "\${HOME}/Documents";
      download = "\${HOME}/Downloads";
      music = "\${HOME}/Music";
      pictures = "\${HOME}/Pictures";
      publicShare = "\${HOME}/Public";
      templates = "\${HOME}/Templates";
      videos = "\${HOME}/Videos";
    };
  };

  # Create wallpaper directory
  home.file.".local/share/wallpapers/.keep".text = "";

  # Misc
  programs.git = {
    enable = true;
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };
}
