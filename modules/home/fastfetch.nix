{
  config,
  lib,
  ...
}:
{
  options.modules.home.fastfetch = {
    enable = lib.mkEnableOption "Fastfetch Configuration";
  };

  config = lib.mkIf config.modules.home.fastfetch.enable {
    home-manager.users.face.programs.fastfetch = {
      ############################################
      # fastfetch Config
      ############################################
      enable = true;
      settings = lib.fromJSON (
        lib.unsafeDiscardStringContext (lib.readFile "${./../../config/fastfetch.jsonc}")
      );
    };
  };
}
