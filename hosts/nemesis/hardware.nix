{
  config,
  pkgs,
  lib,
  ...
}:
{

  ############################################
  # Hardware Configuration
  ############################################
  hardware.microsoft-surface.kernelVersion = "stable";

  hardware.cpu.intel.updateMicrocode = true;
  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  ############################################
  # Bootloader Configuration
  ############################################
  boot.loader.systemd-boot.enable = pkgs.lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.enable = pkgs.lib.mkForce false;
  # boot.loader.systemd-boot.windows.windows.title="Windows 11";
  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;

  ############################################
  # Surface-related things
  ############################################
  services.iptsd.enable = true;
  environment.systemPackages = [ pkgs.surface-control ];

  ############################################
  # Nvidia Graphics Configuration
  ############################################
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true; # accessible via `nvidia-settings`.

  hardware.nvidia.prime.offload.enable = true;
  hardware.nvidia.prime.offload.enableOffloadCmd = true;
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:243:0:0";

  # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  # Enable this if you have graphical corruption issues or application crashes after waking
  # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
  # of just the bare essentials.
  hardware.nvidia.powerManagement.enable = false;

  # Fine-grained power management. Turns off GPU when not in use.
  # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  hardware.nvidia.powerManagement.finegrained = false;

  boot.extraModprobeConfig = ''
    options nvidia "NVreg_DynamicPowerManagement=0x00
  '';

  ############################################
  #  hardware-configuration.nix
  ############################################
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5ad1e2a9-84d0-45e1-8663-2b6744626d57";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8466-FDF4";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5813e031-07db-4496-b818-11e165caeee7"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
