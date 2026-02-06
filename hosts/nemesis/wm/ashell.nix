{ pkgs, ... }:
{
  home-manager.users.face = {
    programs.ashell.enable = true;
    programs.ashell.package = pkgs.ashell;

    programs.ashell.settings.position = "Top";

    programs.ashell.settings.modules.left = [
      "Workspaces"
    ];

    programs.ashell.settings.modules.center = [

    ];

    programs.ashell.settings.modules.right = [
      "SystemInfo"
      [
        "Clock"
        "Privacy"
        "Settings"
        "Tray"
      ]
    ];

    programs.ashell.settings.appearance.style = "Islands";

    programs.ashell.settings.workspaces.enable_workspace_filling = true;
    programs.ashell.settings.workspaces.max_workspace = 6;

    programs.ashell.settings.clock.format = ":%D | %H:%M";

    programs.ashell.settings.settings.indicators = [
      "IdleInhibitor"
      "PowerProfile"
      "Audio"
      "Bluetooth"
      "Network"
      "Battery"
    ];
    programs.ashell.settings.settings.shutdown_cmd = "shutdown now";
    programs.ashell.settings.settings.suspend_cmd = "hyprlock & sleep 0.5; systemctl suspend";
    programs.ashell.settings.settings.hibernate_cmd = "hyprlock & sleep 0.5; systemctl hibernate";
    programs.ashell.settings.settings.reboot_cmd = "systemctl reboot";
    programs.ashell.settings.settings.logout_cmd = "loginctl kill-user $(whoami)";
    programs.ashell.settings.setting.battery_format = "IconAndPercentage";
    programs.ashell.settings.setting.peripheral_battery_format = "Icon";
    programs.ashell.settings.settings.audio_sinks_more_cmd = "${pkgs.hyprpwcenter}/bin/hyprpwcenter";
    programs.ashell.settings.settings.audio_sources_more_cmd = "${pkgs.hyprpwcenter}/bin/hyprpwcenter";
    programs.ashell.settings.settings.lock_cmd = "${pkgs.hyprlock}/bin/hyprlock &";
    programs.ashell.settings.settings.wifi_more_cmd =
      "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
    programs.ashell.settings.settings.bluetooth_more_cmd = "${pkgs.blueman}/bin/blueman-manager";

  };
}
