{ pkgs, ... }:
{
  home-manager.users.face = {
    programs.ashell.enable = true;
    programs.ashell.package = pkgs.ashell;
    programs.ashell.settings = {

      position = "Top";

      modules.left = [
        "Workspaces"
      ];

      modules.center = [

      ];

      modules.right = [
        "SystemInfo"
        [
          "Tray"
          "Privacy"
          "Settings"
        ]
        "Clock"
      ];

      appearance.style = "Islands";
      appearance.scale_factor = 1.5;
      appearance.primary_color = "#3686fd";
      appearance.workspace_colors = [ "#3686fd" ];
      appearance.special_workspace_colors = [ "#fd3b3b" ];

      workspaces.enable_workspace_filling = true;
      workspaces.max_workspaces = 6;

      clock.format = "%D | %H:%M";

      settings.indicators = [
        "IdleInhibitor"
        "PowerProfile"
        "Audio"
        "Bluetooth"
        "Network"
        "Battery"
      ];
      settings.shutdown_cmd = "shutdown now";
      settings.suspend_cmd = "hyprlock & sleep 0.5; systemctl suspend";
      settings.hibernate_cmd = "hyprlock & sleep 0.5; systemctl hibernate";
      settings.reboot_cmd = "systemctl reboot";
      settings.logout_cmd = "loginctl kill-user $(whoami)";
      settings.battery_format = "IconAndPercentage";
      settings.peripheral_battery_format = "Icon";
      settings.audio_sinks_more_cmd = "${pkgs.hyprpwcenter}/bin/hyprpwcenter";
      settings.audio_sources_more_cmd = "${pkgs.hyprpwcenter}/bin/hyprpwcenter";
      settings.lock_cmd = "${pkgs.hyprlock}/bin/hyprlock &";
      settings.wifi_more_cmd = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      settings.bluetooth_more_cmd = "${pkgs.blueman}/bin/blueman-manager-wrapped";

    };
  };
}
