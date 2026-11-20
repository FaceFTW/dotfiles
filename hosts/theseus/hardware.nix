{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
  ];

  ############################################
  # Hardware Configuration
  ############################################
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.framework.enableKmod = true;

  services.tlp.enable = false;
  services.iptsd.enable = true;
  services.fprintd.enable = true;
  services.fprintd.enablePam = true;

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
  boot.loader.limine.style.wallpapers = [
    ./assets/fraud-1-wallpaper.png
    ./assets/fraud-2-wallpaper.png
    ./assets/fraud-3-wallpaper.png
  ];
  boot.loader.limine.style.interface.branding = "ENTERING LAYER 8 - FRAUD";

  services.bootvine.enable = true;

  ############################################
  # udev rules
  ############################################
  services.udev.enable = true;

  ############################################
  # Nvidia Graphics Configuration
  ############################################
  hardware.graphics.enable = true;

}
