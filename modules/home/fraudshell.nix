{
  config,
  lib,
  ...
}:
{
  options.modules.home.fraudshell = {
    enable = lib.mkEnableOption "FRAUDSHELL (Quickshell config files)";
  };

  config = lib.mkIf config.modules.home.fraudshell.enable {
    home-manager.users.face.home.file."~/.config/quickshell/fraudshell" = {
      source = ../fraudshell;
      recursive = true;
    };
  };

}
