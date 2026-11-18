{
  config,
  lib,
  ...
}:
{
  options.modules.packages.ssh-client = {
    enable = lib.mkEnableOption "SSH Client Configuration";
  };

  config = lib.mkIf config.modules.packages.ssh-client.enable {
    home-manager.users.face.programs.ssh = {
      ############################################
      # SSH Client Config
      ############################################
      enable = true;
      enableDefaultConfig = false;

      settings."*".AddKeysToAgent = "yes";
    };
  };
}
