{ config, pkgs, ... }:
{

  ############################################
  # Hardware Configuration
  ############################################
  hardware.microsoft-surface.kernelVersion = "stable";

  hardware.cpu.intel.updateMicrocode = true;
  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  hardware.bluetooth.enable = true;
  ############################################
  # Kernel Config
  ############################################
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "nvidia"
    "i915"
    "nvidia_modeset"
    "nvidia_drm"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "btusb"
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  ############################################
  # Bootloader Configuration
  ############################################
  boot.loader.limine.enable = true;
  boot.loader.limine.secureBoot.enable = true;
  boot.loader.limine.additionalFiles."efi/memtest86/memtest86.efi" =
    "${pkgs.memtest86-efi}/BOOTX64.efi";

  boot.loader.limine.extraEntries = ''
    /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi#bf54ae4c759a239c2dc64dd6c48e1cc742e9666c2544714e70dc789a2b0e019731012cb68d64c22a7e4cbe505c556ba9d6c92072dcac53043f224e2fe5e69ab2
  '';
  boot.loader.efi.canTouchEfiVariables = true;

  ############################################
  # Surface-related things
  ############################################
  services.iptsd.enable = true;
  environment.systemPackages = [ pkgs.surface-control ];

  hardware.sensor.iio.enable = false; # Sometimes there are annoying rotations that happen

  ############################################
  # udev rules
  ############################################
  services.udev.enable = true;
  services.udev.extraRules = ''
    KERNEL=="card*", KERNELS=="0000:00:02.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/intel_gpu"
    KERNEL=="card*", KERNELS=="0000:00:f3.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia_gpu"
  '';

  ############################################
  # Nvidia Graphics Configuration
  ############################################
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia.open = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
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
    options nvidia "NVreg_DynamicPowerManagement=0x00"
  '';

  ############################################
  # Filesystem Config
  ############################################
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

  fileSystems."/mnt/citadel" = {
    device = "/dev/disk/by-uuid/293CD3DA2A50BE4A";
    fsType = "ntfs";
    options = [
      "noatime"
      "discard"
      "uid=face"
      "gid=users"
      "dmask=0002"
      "fmask=0002"
      "acl"
      "windows_names"
      # "iocharset=utf8"
    ];

  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5813e031-07db-4496-b818-11e165caeee7"; }
  ];

}
