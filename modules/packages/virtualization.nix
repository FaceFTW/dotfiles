{
  config,
  pkgs,
  lib,
  ...
}:
let
  virtualization = config.modules.packages.virtualization;
  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.modules.packages.virtualization.docker.enable = mkEnableOption "Docker";
  options.modules.packages.virtualization.armVirtualization.enable =
    mkEnableOption "ARM Virtualization via QEMU";

  config = mkMerge [
    ############################################
    # Docker
    ############################################
    (mkIf virtualization.docker.enable {
      environment.systemPackages = [
        pkgs.docker
        pkgs.docker-compose
      ];

      virtualisation.docker = mkIf virtualization.docker.enable {
        enable = true;
        logDriver = "json-file";
      };
    })

    ############################################
    # ARM Virtualization
    ############################################
    (mkIf virtualization.armVirtualization.enable {
      environment.systemPackages = [
        pkgs.qemu
      ];

      # For cross-compiling Raspberry-Pi things
      boot.binfmt.emulatedSystems = mkIf virtualization.armVirtualization.enable [ "aarch64-linux" ];
    })
  ];
}
