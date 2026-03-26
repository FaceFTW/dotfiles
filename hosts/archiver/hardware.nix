{
  pkgs,
  ...
}:
{
  ############################################
  # Hardware Configuration
  ############################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "uas"
    "sd_mod"
    "sdhci_pci"
    "mmc_block"
  ];
  boot.initrd.systemd.enable = true;

  boot.extraModulePackages = [ pkgs.kernelModules.ugreen_led ];
  boot.kernelModules = [
    "led-ugreen"
    "i2c-dev"
    "ledtrig-netdev"
    "ledtrig-oneshot"
    "igc"
    "kvm-intel"
    "i915"
  ];
  boot.kernelParams = [
    "pcie_port_pm=off"
    "pcie_aspm.policy=performance"
    "consoleblank=0"
    "fbcon=logo-count:1"
    "fbcon=font:ter-v14n"
    "vconsole.font=ter-v14n"
  ];
  # boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  # boot.loader.systemd-boot.memtest86.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [
    pkgs.intel-ocl
    pkgs.intel-media-driver
    pkgs.vpl-gpu-rt
  ];

  services.udev.enable = true;

}
