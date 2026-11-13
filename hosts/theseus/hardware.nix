{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
  ];

  ############################################
  # Hardware Configuration
  ############################################
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.framework.enableKmod = true;

  ############################################
  # Kernel Config
  ############################################
  boot.kernelPackages = pkgs.linuxPackages_7_3;

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  # so I can play deadlock
  boot.kernel.sysctl."vm.max_map_count" = 1048576;

  ############################################
  # Bootloader Configuration
  ############################################
  boot.loader.limine.enable = true;
  boot.loader.limine.secureBoot.enable = true;
  boot.loader.limine.additionalFiles."efi/memtest86/memtest86.efi" =
    "${pkgs.memtest86-efi}/BOOTX64.efi";
  boot.loader.efi.canTouchEfiVariables = true;

  ############################################
  # Surface-related things
  ###########################################
  services.tlp.enable = false;
  hardware.enableRedistributableFirmware = true;
  services.iptsd.enable = true;
  environment.systemPackages = [ pkgs.surface-control ];

  ############################################
  # udev rules
  ############################################
  services.udev.enable = true;

  ############################################
  # Nvidia Graphics Configuration
  ############################################
  hardware.graphics.enable = true;

}
