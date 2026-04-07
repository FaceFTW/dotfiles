{
  pkgs,
  ...
}:
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
    programs.waybar.style = ./waybar.css;
    programs.waybar.settings.mainBar = {
      reload_style_on_change = true;
      position = "top";
      margin-top = 2;
      height = 32;
      width = 2380;
      margin-bottom = 0;

      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "tray"
        "backlight"
        "bluetooth"
        "pulseaudio"
        "network"
        "memory"
        "cpu"
        "battery"
      ];

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}: {windows}";
        format-window-separator = " ";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
        };
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
        workspace-taskbar = {
          enable = true;
          update-active-window = false;
          format = "{icon}";
          icon-size = 28;
          on-click-window = "${focus_window}/bin/focus-window.sh {address} {button}";
        };
      };

      cpu = {
        interval = 5;
        format = "{usage}% 󰍛";
        # "on-click"= "omarchy-launch-or-focus-tui btop"
      };

      clock = {
        "format" = "{:%d/%m/%Y  %H:%M:%S}";
        "tooltip-format" = "<span>{calendar}</span>";
        "calendar" = {
          mode = "month";
          weeks-pos = "right";
          mode-mon-col = 3;
          on-click-right = "mode";
          format = {
            "month" = "<span color='#ffead3'><b>{}</b></span>";
            "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
            "today" = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
      };

      network = {
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        nospacing = 1;
        on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      "battery" = {
        format = "{capacity}% {icon}";
        format-discharging = "{capacity}% {icon}";
        format-charging = "{capacity}% {icon}";
        format-plugged = "{power}";
        format-icons = {
          charging = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        format-full = "󰂅";
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        interval = 5;
        states = {
          warning = 20;
          critical = 10;
        };
      };

      bluetooth = {
        format = "";
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-connected = "";
        tooltip-format = "Devices connected: {num_connections}";
        on-click = "${pkgs.blueman}/bin/blueman-manager-wrapped";
      };

      # "backlight": {
      #   "device": "intel_backlight",
      #   "format": "{percent}% {icon}",
      #   "format-icons": [
      #     "🌑",
      #     "🌘",
      #     "🌗",
      #     "🌖",
      #     "🌕"
      #   ]
      # },

      "memory" = {
        "interval" = 2;
        "format" = "{percentage}% ";
        # "on-click": "omarchy-launch-or-focus-tui btop"
      };

      "pulseaudio" = {
        "format" = "{icon}";
        "on-click" = "";
        "on-click-right" = "${pkgs.hyprpwcenter}/bin/hyprpwcenter";
        "tooltip-format" = "Playing at {volume}%";
        "scroll-step" = 5;
        "format-muted" = "";
        "format-icons" = {
          "default" = [
            ""
            ""
            ""
          ];
        };
      };

      "tray" = {
        "icon-size" = 28;
        "spacing" = 28;
      };
    };
  };
}
