{ pkgs, ... }:
{
  home-manager.users.face = {
    programs.waybar.enable = true;
    programs.waybar.style = ./assets/waybar.css;
    programs.waybar.settings = {
      mainBar = {
        "layer" = "top";
        "spacing" = 10;
        "modules-left" = [
          "custom/menu"
          "wlr/taskbar"
        ];
        "modules-right" = [
          "tray"
          "power-profiles-daemon"
          "temperature"
          "pulseaudio"
          "bluetooth"
          "network"
          "battery"
          "clock"
        ];

        # Modules configuration
        "wlr/taskbar" = {
          "format" = "{icon}";
          "icon-size" = 30;
          "icon-theme" = "Numix-Circle";
          "tooltip-format" = "{title}";
          "on-click" = "activate";
          "on-click-middle" = "close";
          "rewrite" = {
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
        };

        "temperature" = {
          "critical-threshold" = 80;
          "format" = " {temperatureC}°C";
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
          "format-charging" = "{capacity}% ";
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
          "format-wifi" = "{signalStrength}%  ";
          "format-ethernet" = "Connected \udb80\ude01 ";
          "tooltip-format" = "{ifname} via {gwaddr} \uf0ac";
          "format-linked" = "{ifname} (No IP) \udb83\udd1b";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}= {ipaddr}/{cidr}";
          "on-click-right" = "nm-connection-editor";
        };

        "custom/menu" = {
          "format" = "{icon} ";
          "format-icons" = [ "" ];
          "tooltip" = "Open Menu";
          "on-click" = "${pkgs.vicinae}/bin/vicinae toggle";
          "menu" = "on-click-right";
          "menu-file" = "$HOME/.config/waybar/options_menu.xml";
          "menu-actions" = {
            "drun" = "${pkgs.vicinae}/bin/vicinae toggle";
          };
        };
      };
    };
  };
}
