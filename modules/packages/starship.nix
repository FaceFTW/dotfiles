{
  config,
  lib,
  ...
}:
{

  options.modules.packages.starship = {
    enable = lib.mkEnableOption "Starship (User installation only)";
  };

  config = lib.mkIf config.modules.packages.starship.enable {
    home-manager.users.face.programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = lib.fromTOML (
        lib.unsafeDiscardStringContext (lib.readFile "${./../../config/starship.toml}")
      );
    };
  };
}
