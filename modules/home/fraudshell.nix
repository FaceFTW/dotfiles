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
    home-manager.users.face.xdg.configFile."quickshell/fraudshell" = {
      enable = true;
      force = true;
      source = ../fraudshell;
      # recursive = true;
    };
  };

}
