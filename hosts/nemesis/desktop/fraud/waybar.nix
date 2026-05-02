{
  lib,
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

  dunst-check = pkgs.writeShellScriptBin "check-dunst.sh" ''
    COUNT=$(${pkgs.dunst}/bin/dunstctl count waiting)
    ENABLED=
    DISABLED=
    if [ $COUNT != 0 ]; then DISABLED=" $COUNT"; fi
    if ${pkgs.dunst}/bin/dunstctl is-paused | grep -q "false" ; then echo $ENABLED; else echo $DISABLED; fi
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
        "power-profiles-daemon"
        "group/perf"
        "bluetooth"
        "pulseaudio"
        "network"
        "battery"
        "custom/dunst"
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

      "group/perf" = {
        orientation = "horizontal";
        modules = [
          "cpu"
          "memory"
        ];
      };

      cpu = {
        interval = 5;
        format = "󰍛 {usage}%";
      };
      memory = {
        interval = 5;
        format = " {percentage}%";
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
        on-click = "${pkgs.blueman}/bin/blueman-manager";
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

      power-profiles-daemon = {
        format = "{icon} ";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
          "default" = "";
          "performance" = "";
          "balanced" = "";
          "power-saver" = "";
        };
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

      "custom/dunst" = {
        "exec" = "${lib.getExe dunst-check}";
        "on-click" = "${pkgs.dunst}/bin/dunstctl history-pop";
        "on-right-click" = "${pkgs.dunst}/bin/dunstctl set-paused toggle";
        "restart-interval" = 5;
      };
    };
  };
}
