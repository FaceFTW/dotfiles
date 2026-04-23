{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # inputs.nixos-hardware.nixosModules.microsoft-surface-common
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  ############################################
  # Hardware Configuration
  ############################################
  # hardware.microsoft-surface.kernelVersion = "stable";

  hardware.cpu.intel.updateMicrocode = true;
  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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

  boot.loader.limine.extraEntries = ''
    /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi#bf54ae4c759a239c2dc64dd6c48e1cc742e9666c2544714e70dc789a2b0e019731012cb68d64c22a7e4cbe505c556ba9d6c92072dcac53043f224e2fe5e69ab2
  '';
  boot.loader.efi.canTouchEfiVariables = true;

  ############################################
  # Surface-related things
  ###########################################
  services.tlp.enable = false;
  hardware.enableRedistributableFirmware = true;
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

  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true; # accessible via `nvidia-settings`.

  # By default, use Prime offload, unless we use the sync specialization
  hardware.nvidia.prime.offload.enable = lib.mkIf (config.specialisation != { }) true;
  hardware.nvidia.prime.offload.enableOffloadCmd = lib.mkIf (config.specialisation != { }) true;
  specialisation.prime-sync.configuration = {
    hardware.nvidia.prime.sync.enable = true;
  };

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

  # If I ever experience the bug where the dGPU is stuck in D3Cold,
  # uncomment this but remember it keeps it always on
  #   boot.extraModprobeConfig = ''
  #     options nvidia "NVreg_DynamicPowerManagement=0x00"
  #   '';

}
