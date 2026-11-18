{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.packages.fastfetch = {
    enable = lib.mkEnableOption "Fastfetch (System and user install with configuration)";
  };

  config = lib.mkIf config.modules.packages.fastfetch.enable {
    environment.systemPackages = [ pkgs.fastfetch ];

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
