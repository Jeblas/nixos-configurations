{ config, pkgs, lib, ... }:
let
  # Atlanta, Georgia (33.7490 N, 84.3880 W)
  location = {
    latitude = 33.7490;
    longitude = -84.3880;
  };
in
{
  # Applications from environments/hyprland-desktop.nix that support
  # declarative config. The compositor itself is still started system-wide.

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Hack Nerd Font";
      font_size = 11;
      background_opacity = "0.95";
      window_padding_width = 8;
      confirm_os_window_close = 0;
    };
  };

  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      prompt = "Search";
      width = 600;
      height = 400;
      location = "center";
      allow_images = true;
      insensitive = true;
    };
    style = ''
      * {
        font-family: "Hack Nerd Font", monospace;
        font-size: 13px;
      }

      window {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border: 2px solid #89b4fa;
        border-radius: 8px;
      }

      #input {
        margin: 8px;
        padding: 8px;
        border: none;
        border-radius: 4px;
        background-color: #313244;
        color: #cdd6f4;
      }

      #entry {
        padding: 6px;
      }

      #entry:selected {
        background-color: #89b4fa;
        color: #1e1e2e;
      }
    '';
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "bottom";
        height = 30;
        spacing = 8;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/mode"
          "hyprland/scratchpad"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "privacy"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "power-profiles-daemon"
          "cpu"
          "memory"
          "temperature"
          "keyboard-state"
          "clock"
          "tray"
        ];

        "hyprland/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "hyprland/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [ "" "" ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "cpu" = {
          format = "{max_frequency}GHz {usage}% ";
          tooltip = false;
        };

        "memory" = {
          format = "{}% ";
        };

        "temperature" = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip = true;
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "privacy" = {
          icon-spacing = 4;
          icon-size = 18;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
        };

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
      }
    ];
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "Hack Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 6px;
        color: #cdd6f4;
      }

      #workspaces button.active {
        background-color: #89b4fa;
        color: #1e1e2e;
      }

      #clock,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray,
      #idle_inhibitor,
      #privacy,
      #keyboard-state,
      #power-profiles-daemon {
        padding: 0 8px;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }
    '';
  };

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
      font = "Hack Nerd Font 10";
      icons = true;
      markup = true;
      padding = "8";
      margin = "8";
    };
  };

  # Night mode / blue-light filter. Manual coordinates avoid needing geoclue.
  services.gammastep = {
    enable = true;
    inherit (location) latitude longitude;
    temperature = {
      day = 6500;
      night = 3500;
    };
    settings.general.adjustment-method = "wayland";
  };

  # The compositor already starts hyprpaper from hyprland.conf, so only manage
  # its config here instead of enabling a second systemd instance.
  xdg.configFile."hypr/hyprpaper.conf".text = lib.hm.generators.toHyprconf {
    attrs = {
      splash = false;
      ipc = "on";
      wallpaper = [
        {
          monitor = "DP-1";
          path = "${config.home.homeDirectory}/Documents/Wallpapers/Mountain.png";
          fit_mode = "cover";
        }
        {
          monitor = "DP-2";
          path = "${config.home.homeDirectory}/Documents/Wallpapers/Mountain.png";
          fit_mode = "cover";
        }
      ];
    };
    importantPrefixes = [ "$" "monitor" ];
  };
}
