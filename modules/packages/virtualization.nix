{
  config,
  pkgs,
  lib,
  ...
}:
let
  docker = config.packages.virtualization.docker;
  armVirt = config.packages.virtualization.armVirtualization;
  inherit (lib) mkIf mkEnableOption lists;
in
{
  options.packages.virtualization.docker = mkEnableOption "Docker";
  options.packages.virtualization.armVirtualization = mkEnableOption "ARM Virtualization via QEMU";

  config = {
    environment.systemPackages = lists.flatten [
      (lists.optional docker [
        pkgs.docker
        pkgs.docker-compose
      ])
      (lists.optional armVirt [
        pkgs.qemu
      ])
    ];

    virtualisation.docker = mkIf docker {
      enable = true;
      logDriver = "json-file";
    };

    boot.binfmt.emulatedSystems = mkIf armVirt [ "aarch64-linux" ]; # For Cross-Compiling Raspberry Pi Things
  };
}
