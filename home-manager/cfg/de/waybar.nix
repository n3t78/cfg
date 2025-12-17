{pkgs, ...}: let
  uptimeScript = pkgs.writeShellScript "waybar-uptime" ''
    #!/usr/bin/env bash
    set -euo pipefail

    UPTIME_PRETTY="$(uptime -p)"
    UPTIME_FORMATTED="$(echo "$UPTIME_PRETTY" | sed 's/^up //; s/,*$//; s/minute/m/; s/hour/h/; s/day/d/; s/s//g')"
    echo " $UPTIME_FORMATTED"
  '';
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-bottom = -10;
        spacing = 0;

        # Optional: pin to a display (uncomment if desired)
        # output = [ "DP-1" ];

        modules-left = [
          "hyprland/workspaces"
          "custom/uptime"
          "cpu"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "bluetooth"
          "network"
          "pulseaudio"
          "backlight"
          "temperature"
          "battery"
          "custom/lock"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}: {icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        "custom/uptime" = {
          format = "{}";
          tooltip = false;
          interval = 1600;
          exec = "${uptimeScript}";
        };

        "cpu" = {
          interval = 1;
          format = "  {icon0}{icon1}{icon2}{icon3} {usage:>2}%";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          on-click = "alacritty -e htop";
        };

        "clock" = {
          tooltip = false;
          format = "{:%H:%M:%S  -  %A, %d}";
          interval = 1;
        };

        "bluetooth" = {
          format = "󰂲";
          format-on = "{icon}";
          format-off = "{icon}";
          format-connected = "{icon}";
          format-icons = {
            on = "󰂯";
            off = "󰂲";
            connected = "󰂱";
          };
          on-click = "blueman-manager";
          tooltip-format-connected = "{device_enumerate}";
        };

        "network" = {
          format-wifi = "󰤢";
          format-ethernet = "󰈀 ";
          format-disconnected = "󰤠 ";
          interval = 5;
          tooltip-format = "{essid} ({signalStrength}%)";
          on-click = "nm-connection-editor";
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-muted = "";
          format-icons = {
            default = ["" "" " "];
          };
          on-click = "pavucontrol";
        };

        "backlight" = {
          format = "{icon}  {percent}%";
          format-icons = ["" "󰃜" "󰃛" "󰃞" "󰃝" "󰃟" "󰃠"];
          tooltip = false;
        };

        # CPU TEMP (styled like the other right-bar modules)
        # NOTE: You may need to adjust the path on your machine.
        # Quick way to find one: ls /sys/class/hwmon/hwmon*/temp*_input
        "temperature" = {
          interval = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 85;
          format = "  {temperatureC}°C";
          tooltip = false;
        };

        "battery" = {
          interval = 2;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-full = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
        };

        "custom/lock" = {
          tooltip = false;
          format = "";
          on-click = "sh -c '(sleep 0s; hyprlock)' & disown";
        };
      };
    };

    # Ported to meloira palette
    style = ''
      /* Meloira palette reference
         bg0: #1c1917
         bg1: #24201e
         bg2: #2a2522
         fg0: #d6d0cd
         fg1: #ddd9d6
         red: #d49191
         green: #b6b696
         yellow: #c4b392
         blue: #9e96b6
         magenta: #b696b1
         cyan: #98acc8
      */

      * {
        font-family: "JetBrainsMono Nerd Font", "NotoSans Nerd Font", sans-serif;
        font-size: 13px;
        min-height: 0;
        padding-right: 0px;
        padding-left: 0px;
        padding-bottom: 0px;
        border: none;
      }

      window#waybar {
        background: transparent;
        color: #d6d0cd;
        margin: 0px;
        font-weight: 500;
      }

      /* --- Left modules (individual rounded blocks) --- */
      #workspaces,
      #custom-uptime,
      #cpu {
        background-color: #24201e;
        padding: 0.3rem 0.7rem;
        margin: 5px 0px;
        border-radius: 6px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
        min-width: 0;
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
      }

      #workspaces {
        padding: 2px;
        margin-left: 7px;
        margin-right: 5px;
      }

      #custom-uptime {
        margin-right: 5px;
        color: #ddd9d6;
      }

      #cpu {
        color: #d6d0cd;
      }

      #custom-uptime:hover,
      #cpu:hover {
        background-color: #2a2522;
      }

      #workspaces button {
        color: #b696b1;
        border-radius: 5px;
        padding: 0.3rem 0.6rem;
        background: transparent;
        transition: all 0.2s ease-in-out;
        border: none;
        outline: none;
      }

      #workspaces button.active {
        color: #98acc8;
        background-color: rgba(152, 172, 200, 0.12);
        box-shadow: inset 0 0 0 1px rgba(152, 172, 200, 0.18);
      }

      #workspaces button:hover {
        background: #2a2522;
        color: #ddd9d6;
      }

      /* --- Center module (clock) --- */
      #clock {
        background-color: #24201e;
        padding: 0.3rem 0.7rem;
        margin: 5px 0px;
        border-radius: 6px;
        box-shadow: 0 1px 3px rgba(152, 172, 200, 0.18);
        min-width: 0;
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
        color: #98acc8;
        font-weight: 500;
      }

      #clock:hover {
        background-color: rgba(152, 172, 200, 0.12);
      }

      /* --- Right modules (single seamless bar) --- */
      #bluetooth,
      #network,
      #pulseaudio,
      #backlight,
      #temperature,
      #battery,
      #custom-lock {
        background-color: #24201e;
        padding: 0.3rem 0.7rem;
        margin: 5px 0px;
        border-radius: 0;
        box-shadow: none;
        min-width: 0;
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
      }

      #bluetooth:hover,
      #network:hover,
      #pulseaudio:hover,
      #backlight:hover,
      #temperature:hover,
      #battery:hover,
      #custom-lock:hover {
        background-color: #2a2522;
      }

      /* Left cap of the right bar */
      #bluetooth {
        border-top-left-radius: 6px;
        border-bottom-left-radius: 6px;
        color: #9e96b6;
        font-size: 16px;
      }

      #bluetooth.on {
        color: #98acc8;
      }

      #bluetooth.connected {
        color: #98acc8;
      }

      #network {
        color: #d6d0cd;
      }

      #network.disconnected {
        color: #d49191;
      }

      #pulseaudio {
        color: #d6d0cd;
      }

      #backlight {
        color: #d6d0cd;
      }

      #temperature {
        color: #c4b392;
      }

      #battery {
        color: #98acc8;
      }

      #battery.charging {
        color: #b6b696;
      }

      #battery.warning:not(.charging) {
        color: #d49191;
      }

      /* Right cap of the right bar */
      #custom-lock {
        border-top-right-radius: 6px;
        border-bottom-right-radius: 6px;
        margin-right: 7px;
        color: #b696b1;
      }

      /* Tooltip styling */
      tooltip {
        background-color: #24201e;
        color: #ddd9d6;
        padding: 5px 12px;
        margin: 5px 0px;
        border-radius: 6px;
        border: 1px solid rgba(221, 217, 214, 0.10);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.22);
        font-size: 12px;
      }
    '';
  };
}
