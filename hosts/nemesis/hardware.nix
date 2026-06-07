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
  # Kernel Build Configuration
  ############################################
  modules.kernel = {
      version = "7.0.10";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v7.x/linux-7.0.10.tar.xz";
        hash = "sha256-CUl362LCDj0ZOf6BqSlYofmH8zlEblMvqGljsoBOMtw=";
        # hash = lib.fakeHash;
      };

      patches = [
        {
          ############################################
          # linux-surface patches
          ############################################
          name = "microsoft-surface-patches-linux-v7.0.9";
          patch = ./surface-kernel-patches-v7.0.5.patch;
          structuredExtraConfig = with lib.kernel; {
            ##
            ## Surface Aggregator Module
            ##
            SURFACE_AGGREGATOR = module;
            # SURFACE_AGGREGATOR_ERROR_INJECTION is not set
            SURFACE_AGGREGATOR_BUS = yes;
            SURFACE_AGGREGATOR_CDEV = module;
            SURFACE_AGGREGATOR_HUB = module;
            SURFACE_AGGREGATOR_REGISTRY = module;
            SURFACE_AGGREGATOR_TABLET_SWITCH = module;

            SURFACE_ACPI_NOTIFY = module;
            SURFACE_DTX = module;
            SURFACE_PLATFORM_PROFILE = module;

            SURFACE_HID = module;
            SURFACE_KBD = module;

            BATTERY_SURFACE = module;
            CHARGER_SURFACE = module;

            SENSORS_SURFACE_TEMP = module;
            SENSORS_SURFACE_FAN = module;

            RTC_DRV_SURFACE = module;

            ##
            ## Surface Hotplug
            ##
            SURFACE_HOTPLUG = module;

            ##
            ## IPTS and ITHC touchscreen
            ##
            ## This only enables the user interface for IPTS/ITHC data.
            ## For the touchscreen to work, you need to install iptsd.
            ##
            HID_IPTS = module;
            HID_ITHC = module;
            INTEL_THC_HID = module;
            INTEL_QUICKSPI = module;

            ##
            ## Cameras: IPU3
            ##
            VIDEO_DW9719 = module;
            VIDEO_IPU3_IMGU = module;
            VIDEO_IPU3_CIO2 = module;
            IPU_BRIDGE = module;
            INTEL_SKL_INT3472 = module;
            REGULATOR_TPS68470 = module;
            COMMON_CLK_TPS68470 = module;
            LEDS_TPS68470 = module;

            ##
            ## Cameras: Sensor drivers
            ##
            VIDEO_OV5693 = module;
            VIDEO_OV7251 = module;
            VIDEO_OV8865 = module;

            ##
            ## Surface 3: atomisp causes problems (see issue #1095). Disable it for now.
            ##
            # INTEL_ATOMISP is not set

            ##
            ## ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
            ##
            APDS9960 = module;

            ##
            ## Build-in UFS support (required for some Surface Go devices)
            ##
            SCSI_UFSHCD = module;
            SCSI_UFSHCD_PCI = module;

            ##
            ## Other Drivers
            ##
            INPUT_SOC_BUTTON_ARRAY = module;
            SURFACE_3_POWER_OPREGION = module;
            SURFACE_PRO3_BUTTON = module;
            SURFACE_GPE = module;
            SURFACE_BOOK1_DGPU_SWITCH = module;
            HID_SURFACE = module;

          };
        }
      ];

      extraConfig = with lib.kernel; {
        HFS = yes;
        HFS_PLUS = yes;

        WLAN_VENDOR_INTEL = yes;
        IPW2100 = no;
        IPW2200 = no;
        IWL4965 = no;
        IWL3945 = no;

        LPC_ICH = yes;
        LPC_SCH = yes;
        MFD_INTEL_LPSS_PCI = yes;

        DRM_I915 = yes;

        BATTERY_SURFACE = module;
        CHARGER_SURFACE = module;
        SENSORS_SURFACE_FAN = module;
        SENSORS_SURFACE_TEMP = module;

        SERIAL_8250_DW = module;
        SERIAL_8250_DWLIB = module;

        # Breakfixes for somewhere eventually
        GPIO_RDC321X = no;
      };
    };

    # boot.kernelPackages = recurseIntoAttrs (pkgs.linuxPackagesFor betterLinuxPackage);

    # boot.kernel.buildConfig.patchSets = [
    #   {
    #     name = "rm-unused-fs";
    #     overrides = with lib.kernel; {
    #     };
    #   }
    #   { name = "rm-x86-platform-drivers"; }
    #   { name = "rm-unused-driver-categories"; }
    #   { name = "rm-unused-individual-drivers"; }
    #   { name = "rm-net-top-level"; }
    #   { name = "rm-net-dsa-drivers"; }
    #   { name = "rm-net-ethernet-drivers"; }
    #   {
    #     name = "rm-net-wlan-drivers";
    #     overrides = with lib.kernel; {
    #       WLAN_VENDOR_INTEL = yes;
    #       IPW2100 = no;
    #       IPW2200 = no;
    #       IWL4965 = no;
    #       IWL3945 = no;
    #     };
    #   }
    #   { name = "rm-net-ethernet-specific-phy"; }
    #   { name = "rm-parallel-ata"; }
    #   { name = "rm-unused-graphics"; }
    #   { name = "rm-hid-specific-keyboard"; }
    #   { name = "rm-hid-specific-mouse"; }
    #   { name = "rm-hid-misc"; }
    #   { name = "rm-pcie-top-level"; }
    #   { name = "rm-scsi-top-level"; }
    #   { name = "rm-media-tuners"; }
    #   { name = "rm-dallas-1wire"; }
    #   { name = "rm-watchdogs-timers"; }
    #   {
    #     name = "rm-multifunction-device";
    #     overrides = with lib.kernel; {
    #       LPC_ICH = yes;
    #       LPC_SCH = yes;
    #       MFD_INTEL_LPSS_PCI = yes;
    #     };
    #   }
    #   { name = "rm-specific-regulators"; }
    #   {
    #     name = "rm-specific-graphics-drm";
    #     overrides = with lib.kernel; {
    #       DRM_I915 = yes;
    #     };
    #   }
    #   { name = "rm-specific-backlight-lcd"; }
    #   {
    #     name = "rm-specific-battery-sensors";
    #     overrides = with lib.kernel; {
    #       BATTERY_SURFACE = module;
    #       CHARGER_SURFACE = module;
    #       SENSORS_SURFACE_FAN = module;
    #       SENSORS_SURFACE_TEMP = module;
    #     };
    #   }
    #   { name = "rm-specific-rtc-clocks"; }
    #   { name = "rm-specific-hw-clocks"; }
    #   { name = "rm-specific-pinctrl"; }
    #   {
    #     name = "rm-specific-serial";
    #     overrides = with lib.kernel; {
    #       SERIAL_8250_DW = module;
    #       SERIAL_8250_DWLIB = module;
    #     };
    #   }
    # ];
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
