{
  config,
  lib,
  ...
}:
{
  options.modules.packages.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper (User Install Only)";
    defaultWallpaper = lib.mkOption {
      type = with lib.types; path;
    };
  };

  config = lib.mkIf config.modules.packages.hyprpaper.enable {
    home-manager.users.face.services.hyprpaper = {
      enable = true;
      settings.wallpaper = [
        {
          monitor = "eDP-1";
          path = builtins.toString config.modules.packages.hyprpaper.defaultWallpaper;
          fit_mode = "contain";
        }
      ];
      settings.splash = false;
    };
  };
}
