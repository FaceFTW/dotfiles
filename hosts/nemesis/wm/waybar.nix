{ ... }:
{
  home-manager.users.face = {
    programs.waybar.enable = true;
    programs.waybar.style = ./assets/waybar.css;
    programs.waybar.settings = {
      mainBar = {
        "layer" = "top";
        "spacing" = 10;
        "modules-left" = [
          "tray"
        ];
        "modules-right" = [
          "wlr/taskbar"
          "pulseaudio"
          "network"
          "power-profiles-daemon"
          "temperature"
          "keyboard-state"
          "battery"
          "bluetooth"
          "clock"
        ];

        # Modules configuration
        "keyboard-state" = {
          "numlock" = true;
          "capslock" = false;
          "format" = "{icon}{name}";
          "format-icons" = {
            "locked" = " ";
            "unlocked" = " ";
          };
        };

        "wlr/taskbar" = {
          "format" = "{icon}";
          "icon-size" = 30;
          "icon-theme" = "Numix-Circle";
          "tooltip-format" = "{title}";
          "on-click" = "activate";
          "on-click-middle" = "close";
          "rewrite" = {
            "Firefox Web Browser" = "Firefox";
            "Foot Server" = "Terminal";
          };
        };

        "tray" = {
          "icon-size" = 21;
          "spacing" = 5;
          "show-passive-items" = true;
        };

        "clock" = {
          "timezone" = "New York";
          "format" = "{:%a %d %b %Y | %H:%M}";
          "tooltip-format" = "<big><tt><small>{calendar}</small></tt></big>";
          "on-click" = "~/.config/hypr/scripts/float_calendar.sh";
        };

        "temperature" = {
          "critical-threshold" = 80;
          "format" = " {temperatureC}°C {icon}";
          "format-icons" = [
            ""
            ""
            ""
          ];
          "on-click" = "psensor";
        };

        "battery" = {
          "states" = {
            "good" = 80;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-full" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "power-profiles-daemon" = {
          "format" = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          "tooltip" = true;
          "format-icons" = {
            "default" = "";
            "performance" = " Max";
            "balanced" = " Mid";
            "power-saver" = " Low";
          };
        };

        "network" = {
          "format-wifi" = "{signalStrength}% ";
          "format-ethernet" = "Connected ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}= {ipaddr}/{cidr}";
          "on-click-right" = "nm-connection-editor";
        };
      };
    };
  };
}
