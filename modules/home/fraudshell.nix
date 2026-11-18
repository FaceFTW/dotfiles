{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.home.fraudshell = {
    enable = lib.mkEnableOption "FRAUDSHELL (Quickshell config files)";
  };

  config = lib.mkIf config.modules.home.fraudshell.enable {
    home-manager.users.face.home.activation = {
      quickshell-link = config.home-manager.users.face.lib.dag.entryAfter [ "writeBoundary" ] ''
        run ln -sf $VERBOSE_ARG /home/face/.config/dotfiles/modules/fraudshell /home/face/.config/quickshell/fraudshell
      '';
    };

    environment.systemPackages = [
      pkgs.quickshell

      # Used by Quickshell procs
      pkgs.ddcutil
      pkgs.networkmanager
      pkgs.power-profiles-daemon
    ];
  };
}
