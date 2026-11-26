{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.packages.hypridle = {
    enable = lib.mkEnableOption "Hypridle (User Configuration)";
  };

  config = lib.mkIf config.modules.packages.hypridle.enable {
    home-manager.users.face.services.hypridle = {
      enable = true;
      settings = {
        general.lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
        general.before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        general.inhibit_sleep = 3;
      };
    };
  };

}
