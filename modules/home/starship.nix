{
  config,
  lib,
  ...
}: {

  options.modules.home.starship = {
    enable = lib.mkEnableOption "Starship";
  };

  config = lib.mkIf config.modules.home.starship.enable {
    home-manager.users.face.programs.starship = {
      enable = true;
      enableZshIntegraion = true;
      settings = lib.fromTOML (
        lib.unsafeDiscardStringContext (lib.readFile "${./../../config/starship.toml}")
      );
    };
  };
}
