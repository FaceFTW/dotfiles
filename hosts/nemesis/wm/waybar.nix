{ pkgs, ... }:
let
  focus_window = pkgs.writeShellScriptBin "focus-window.sh" ''
    address=$1
    # https://api.gtkd.org/gdk.c.types.GdkEventButton.button.html
    button=$2

    if [ $button -eq 1 ]; then
        # Left click: focus window
        hyprctl keyword cursor:no_warps true
        hyprctl dispatch focuswindow address:$address
        hyprctl keyword cursor:no_warps false
    elif [ $button -eq 2 ]; then
        # Middle click: close window
        hyprctl dispatch closewindow address:$address
    fi
  '';
in

{
  home-manager.users.face = {
    programs.waybar.enable = true;
    programs.waybar.style = ./assets/waybar.css;
    programs.waybar.settings = {
      mainBar = {
        layer = "top";
        spacing = 10;
        modules-left = [
          "custom/menu"
          "hyprland/workspaces"
        ];
        modules-right = [
          "tray"
          "power-profiles-daemon"
          # "temperature"
          "pulseaudio"
          "network"
          "battery"
          "clock"
        ];

        # Modules configuration
        # "wlr/taskbar" = {
        #   format = "{icon}";
        #   icon-size = 30;
        #   icon-theme = "Numix-Circle";
        #   tooltip-format = "{title}";
        #   on-click = "activate";
        #   on-click-middle = "close";
        #   rewrite = {
        #   };
        # };

        "hyprland/workspaces" = {
          persistent-workspaces."*" = 4;
          format = "{icon}: {windows}";
          workspace-taskbar.enable = true;
          workspace-taskbar.update-active-window = true;
          workspace-taskbar.format = "{icon}";
          workspace-taskbar.icon-size = 24;
          workspace-taskbar.on-click = "${focus_window}/bin/focus-window.sh {address} {button}";

        };

        tray = {
          icon-size = 24;
          spacing = 5;
          show-passive-items = true;
        };

        clock = {
          timezone = "New York";
          format = "{:%D | %H:%M}";
          tooltip-format = "<big><tt><small>{calendar}</small></tt></big>";
          calendar = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        # temperature = {
        #   critical-threshold = 80;
        #   format = " {temperatureC}°C";
        #   on-click = "psensor";
        # };

        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = " Max";
            balanced = " Mid";
            power-saver = " Low";
          };
          on-click-right = "${pkgs.tuned}/bin/tuned-gui";
        };

        pulseaudio = {
          format-muted = "";
          on-click = "${pkgs.hyprpwcenter}/bin/hyprpwcenter";
        };

        network = {
          format-wifi = "{signalStrength}%  ";
          format-ethernet = "Connected \udb80\ude01 ";
          tooltip-format = "{ifname} via {gwaddr}  \n SSID: {essid} \n Signal: {signalStrength}% ({signaldBm} dB)";
          format-linked = "{ifname} (No IP) \udb83\udd1b";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}= {ipaddr}/{cidr}";
          on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };

        "custom/menu" = {
          format = "{icon} ";
          format-icons = [ "" ];
          tooltip = "Open Menu";
          on-click = "${pkgs.vicinae}/bin/vicinae toggle";
        };
      };
    };
  };
}
