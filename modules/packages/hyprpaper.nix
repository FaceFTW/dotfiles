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
    additionalWallpaperLinks = lib.mkOption {
      description = ''
        Additional paths to wallpapers that should be linked in the `~/.config` folder.
        This is useful if the desire is to have dynamic wallpaper switching via
        hyprctl IPC or some other mechanism.

        Wallpapers will be linked under `~/.config/wallpapers`.
      '';
      type = with lib.types; listOf path;
      default = [ ];
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

    home-manager.users.face.home.activation = {
      wallpapers = config.home-manager.users.face.lib.dag.entryAfter [ "writeBoundary" ] (
        lib.concatMapStringsSep "\n" (
          x: "run ln -sf ${(builtins.toString x)} /home/face/.config/wallpapers/"
        ) config.modules.packages.hyprpaper.additionalWallpaperLinks
      );
    };
  };
}
