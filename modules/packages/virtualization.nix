{
  config,
  pkgs,
  lib,
  ...
}:
let
  docker = config.modules.packages.virtualization.docker;
  armVirt = config.modules.packages.virtualization.armVirtualization;
  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.modules.packages.virtualization.docker = mkEnableOption "Docker";
  options.modules.packages.virtualization.armVirtualization =
    mkEnableOption "ARM Virtualization via QEMU";

  config = mkMerge [
    ############################################
    # Docker
    ############################################
    (mkIf docker {
      environment.systemPackages = [
        pkgs.docker
        pkgs.docker-compose
      ];

      virtualisation.docker = mkIf docker {
        enable = true;
        logDriver = "json-file";
      };
    })

    ############################################
    # ARM Virtualization
    ############################################
    (mkIf armVirt {
      environment.systemPackages = [
        pkgs.qemu
      ];

      # For cross-compiling Raspberry-Pi things
      boot.binfmt.emulatedSystems = mkIf armVirt [ "aarch64-linux" ];
    })
  ];
}
