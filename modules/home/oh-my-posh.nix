{
  config,
  lib,
  ...
}:
{
  options.modules.home.oh-my-posh = {
    enable = lib.mkEnableOption "oh-my-posh Configuration";
  };

  config = lib.mkIf config.modules.home.oh-my-posh.enable {
    home-manager.users.face.programs.oh-my-posh = {
      ############################################
      # Oh My Posh Config
      ############################################
      enable = true;
      enableZshIntegration = true;
      settings = lib.fromJSON (
        lib.unsafeDiscardStringContext (lib.readFile "${./../../config/omp-theme.json}")
      );
    };
  };
}
