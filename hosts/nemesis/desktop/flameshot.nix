{
  ...
}:
{
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
}
