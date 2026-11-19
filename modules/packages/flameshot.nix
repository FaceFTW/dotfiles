{
  config,
  lib,
  ...
}:
{
  options.modules.packages.flameshot = {
    enable = lib.mkEnableOption "Flameshot (User install only)";
  };

  config = lib.mkIf config.modules.packages.flameshot.enable {

    home-manager.users.face.services.flameshot = {
      enable = true;
      settings = {
        General.disabledGrimWarning = true;
        General.useGrimAdapter = true;
        General.disabledTrayIcon = true;
        General.uiColor = "#3686bd";
        General.contrastColor = "#2060a0";
        General.checkForUpdates = false;
      };
    };
  };
}
