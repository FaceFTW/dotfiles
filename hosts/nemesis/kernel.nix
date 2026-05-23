# Bringing in the nixos-hardware version of the Microsoft
# Surface kernel because otherwise I can't apply additional
# config patches that I want
{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    recurseIntoAttrs
    mkForce
    ;

  betterLinuxPackage = pkgs.buildLinux {
    version = "7.0.9";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v7.x/linux-7.0.9.tar.xz";
      hash = "sha256-rAes33bPRiHMUYeiZwJwoaaZUzyKayJeSHjEFq2D8cQ=";
      # hash = lib.fakeHash;
    };

    kernelPatches = [
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

      ############################################
      # Config to reduce extra module builds
      ############################################
      # These are modules that I really will likely not need
      {
        name = "98-dont-build-unused-drivers";
        patch = null;
        structuredExtraConfig = with lib.kernel; {
          # Vulnerability Mitigations
          # None yet

          # CPU Support
          CPU_SUP_AMD = no;
          X86_EXTENDED_PLATFORM = no;
          INTEL_SKL_INT3472 = mkForce no; # Skips a compilation failure introduced in a patch

          # SoC Drivers (Not on an SOC)
          WPCM450_SOC = no;
          QCOM_PMIC_PDCHARGER_ULOG = no;
          QCOM_PMIC_GLINK = no;
          QCOM_PBS = no;
          SOC_TI = no;

          # Cleanup eventually
          SND_SOC_MIKROE_PROTO = no;

          PHYLIB_LEDS = no;
        };
      }
    ];

    ignoreConfigErrors = true;
  };

in
{
  boot.kernelPackages = recurseIntoAttrs (pkgs.linuxPackagesFor betterLinuxPackage);

  boot.kernel.buildConfig.patchSets = [
    {
      name = "rm-unused-fs";
      overrides = with lib.kernel; {
        HFS = yes;
        HFS_PLUS = yes;
      };
    }
    { name = "rm-x86-platform-drivers"; }
    { name = "rm-unused-driver-categories"; }
    { name = "rm-unused-individual-drivers"; }
    { name = "rm-net-top-level"; }
    { name = "rm-net-dsa-drivers"; }
    { name = "rm-net-ethernet-drivers"; }
    {
      name = "rm-net-wlan-drivers";
      overrides = with lib.kernel; {
        WLAN_VENDOR_INTEL = yes;
        IPW2100 = no;
        IPW2200 = no;
        IWL4965 = no;
        IWL3945 = no;
      };
    }
    { name = "rm-net-ethernet-specific-phy"; }
    { name = "rm-parallel-ata"; }
    { name = "rm-unused-graphics"; }
    { name = "rm-hid-specific-keyboard"; }
    { name = "rm-hid-specific-mouse"; }
    { name = "rm-hid-misc"; }
    { name = "rm-pcie-top-level"; }
    { name = "rm-scsi-top-level"; }
    { name = "rm-media-tuners"; }
    { name = "rm-dallas-1wire"; }
    { name = "rm-watchdogs-timers"; }
    {
      name = "rm-multifunction-device";
      overrides = with lib.kernel; {
        LPC_ICH = yes;
        LPC_SCH = yes;
        MFD_INTEL_LPSS_PCI = yes;
      };
    }
    { name = "rm-specific-regulators"; }
    {
      name = "rm-specific-graphics-drm";
      overrides = with lib.kernel; {
        DRM_I915 = yes;
      };
    }
    { name = "rm-specific-backlight-lcd"; }
  ];
}

#  # Fetch the latest linux-surface patches
# linux-surface = pkgs.fetchFromGitHub {
#   owner = "linux-surface";
#   repo = "linux-surface";
#   rev = "321be2e7ebbb751153a97c6ed38836f2f4300dc6";
#   hash = "sha256-ZclXmq4hjGjLofulPsind6il2wBQmeQl3TGvRxfsMp0=";
#   # hash = lib.fakeHash;
# };

# If I ever go back to using linux-surface upstream, uncomment as needed
# {
#   name = "ms-surface/0001-secureboot";
#   patch = patchSrc + "/0001-secureboot.patch";
# }
# {
#   name = "ms-surface/0002-surface3";
#   patch = patchSrc + "/0002-surface3.patch";
# }
# {
#   name = "ms-surface/0003-mwifiex";
#   patch = patchSrc + "/0003-mwifiex.patch";
# }
# {
#   name = "ms-surface/0004-ath10k";
#   patch = patchSrc + "/0004-ath10k.patch";
# }
# {
#   name = "ms-surface/0005-ipts";
#   patch = patchSrc + "/0005-ipts.patch";
# }
# {
#   name = "ms-surface/0006-ithc";
#   patch = patchSrc + "/0006-ithc.patch";
# }
# {
#   name = "ms-surface/0007-surface-sam";
#   patch = patchSrc + "/0007-surface-sam.patch";
# }
# {
#   name = "ms-surface/0008-surface-sam-over-hid";
#   patch = patchSrc + "/0008-surface-sam-over-hid.patch";
# }
# {
#   name = "ms-surface/0009-surface-button";
#   patch = patchSrc + "/0009-surface-button.patch";
# }
# {
#   name = "ms-surface/0010-surface-typecover";
#   patch = patchSrc + "/0010-surface-typecover.patch";
# }
# {
#   name = "ms-surface/0011-surface-shutdown";
#   patch = patchSrc + "/0011-surface-shutdown.patch";
# }
# {
#   name = "ms-surface/0012-surface-gpe";
#   patch = patchSrc + "/0012-surface-gpe.patch";
# }
# {
#   name = "ms-surface/0013-cameras";
#   patch = patchSrc + "/0013-cameras.patch";
# }
# {
#   name = "ms-surface/0014-amd-gpio";
#   patch = patchSrc + "/0014-amd-gpio.patch";
# }
# {
#   name = "ms-surface/0015-rtc";
#   patch = patchSrc + "/0015-rtc.patch";
# }
# {
#   name = "ms-surface/0016-hid-surface";
#   patch = patchSrc + "/0016-hid-surface.patch";
# }
# {
#   name = "ms-surface/0017-powercap";
#   patch = patchSrc + "/0017-powercap.patch";
# }
