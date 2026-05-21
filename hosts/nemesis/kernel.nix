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
    version = "7.0.8";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v7.x/linux-7.0.8.tar.xz";
      hash = "sha256-GUWvsiyfT3x42XEhDzu7fesJ9djEGji/rHct4l9tyyI=";
      # hash = lib.fakeHash;
    };

    kernelPatches = [
      {
        ############################################
        # linux-surface patches
        ############################################
        name = "microsoft-surface-patches-linux-v7.0.8";
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


          CONFIG_QFMT_V1 = no;

          # Graphics
          AGP = mkForce no;
          DRM_AMDGPU = no;
          DRM_AST = no;
          DRM_ETNAVIV = no;
          DRM_GMA500 = mkForce no;
          DRM_GUD = no;
          DRM_HISI_HIBMC = no;
          DRM_I915 = yes; # We do want intel graphics
          DRM_MGAG200 = no;
          DRM_NOUVEAU = no; # Using stupid nvidia proprietary drivers
          DRM_PANEL_RASPBERRYPI_TOUCHSCREEN = no;
          DRM_QXL = no;
          DRM_RADEON = no;
          DRM_ST7571 = no;
          DRM_SSD130x = no;
          DRM_APPLETBDRM = no;
          DRM_BOCHS = no;
          DRM_CIRRUS_QEMU = no;
          DRM_GM12U320 = no;
          DRM_VBOXVIDEO = no;
          DRM_VGEM = no;
          DRM_VMWGFX = no;
          DRM_XE = no;
          FB = mkForce no; # Replaced by DRM/KMS

          # CPU Support
          CPU_SUP_AMD = no;
          X86_EXTENDED_PLATFORM = no;
          AMD_IOMMU_V2 = no;
          INTEL_SKL_INT3472 = mkForce no; # Skips a compilation failure introduced in a patch

          # Networking Drivers
          ARCNET = no;
          B53 = no;
          CAN_NETLINK = no;
          WAN = mkForce no;
          HYPERV_NET = no;
          NET_FC = mkForce no;



          # Display Interface Bridges
          DRM_I2C_NXP_TDA998X = no;
          DRM_ANALOGIX_ANX78XX = no;
          GOOGLE_FIRMWARE = lib.mkForce no;


          # HID/Input Drivers
          MACINTOSH_DRIVERS = no;
          MAC_EMUMOUSEBTN = no;
          KEYBOARD_ADP5585 = no;
          KEYBOARD_ADP5588 = no;
          KEYBOARD_APPLESPI = mkForce no;
          # KEYBOARD_ATKBD = no;
          KEYBOARD_QT1050 = no;
          KEYBOARD_QT1070 = no;
          KEYBOARD_QT2160 = no;
          KEYBOARD_DLINK_DIR685 = no;
          KEYBOARD_LKKBD = no;
          KEYBOARD_TCA8418 = no;
          KEYBOARD_LM8323 = no;
          KEYBOARD_LM8333 = no;
          KEYBOARD_MAX7359 = no;
          KEYBOARD_MAX7360 = no;
          KEYBOARD_MPR121 = no;
          KEYBOARD_NEWTON = no;
          KEYBOARD_OPENCORES = no;
          KEYBOARD_PINEPHONE = no;
          KEYBOARD_SAMSUNG = no;
          KEYBOARD_STOWAWAY = no;
          KEYBOARD_SUNKBD = no;
          KEYBOARD_STMPE = no;
          KEYBOARD_IQS62X = no;
          KEYBOARD_OMAP4 = no;
          KEYBOARD_TM2_TOUCHKEY = no;
          KEYBOARD_XTKBD = no;
          KEYBOARD_CAP11XX = no;
          KEYBOARD_BCM = no;
          KEYBOARD_MTK_PMIC = no;
          KEYBOARD_CYPRESS_SF = no;

          MOUSE_PS2 = no;

          MOUSE_APPLETOUCH = no;
          MOUSE_BCM5974 = no;
          MOUSE_CYAPA = no;
          MOUSE_ELAN_I2C = no;
          MOUSE_VSXXXAA = no;

          JOYSTICK_DB9 = no;
          JOYSTICK_GAMECON = no;
          JOYSTICK_TURBOGRAFX = no;
          JOYSTICK_WALKERA0701 = no;

          INPUT_TABLET = no;
          INPUT_TOUCHSCREEN = no;
          INPUT_MISC = no;


          # SoC Drivers (Not on an SOC)
          WPCM450_SOC = no;
          QCOM_PMIC_PDCHARGER_ULOG = no;
          QCOM_PMIC_GLINK = no;
          QCOM_PBS = no;
          SOC_TI = no;

          # x86 Platform Drivers
          ACERHDF = no; # Acer Aspire One Temp Sensor/Fan
          ACER_WIRELESS = no;
          ACER_WMI = no;
          ACPI_CMPC = no; # Intel Classmate PC from early 20xx
          ADV_SWBUTTON = no; # Advantech software defined button
          AMILO_RFKILL = no; # Wifi for Fujitsu-Siemens Amilo Laptops
          APPLE_GMUX = no; # Gmux on Apple Laptops
          ASUS_ARMORY = no;
          ASUS_LAPTOP = no;
          ASUS_NB_WMI = no;
          ASUS_TF103C_DOCK = no;
          ASUS_WIRELESS = no;
          ASUS_WMI = no;
          AYANEO_EC = no;
          BARCO_P50_GPIO = no;
          COMPAL_LAPTOP = no;
          DASHARO_ACPI = no;
          DELL_LAPTOP = no;
          EEEPC_LAPTOP = no;
          EEEPC_WMI = no;
          FUJITSU_LAPTOP = no;
          FUJITSU_TABLET = no;
          GIGABYTE_WMI = no;
          GPD_POCKET_FAN = no;
          HUAWEI_WMI = no;
          IDEAPAD_LAPTOP = no;
          INSPUR_PLATFORM_PROFILE = no;
          LENOVO_WMI_CAMERA = no;
          LENOVO_WMI_HOTKEY_UTILITIES = no;
          LENOVO_WMI_GAMEZONE = no;
          LENOVO_WMI_TUNING = no;
          LG_LAPTOP = no;
          MERAKI_MX100 = no; # Cisco Meraki MX100 Appliance
          MEEGOPAD_ANX7428 = no;
          MSI_EC = no; # Userspace access for the MSI platform drivers we disabled
          MSI_LAPTOP = no;
          MSI_WMI = no;
          MSI_WMI_PLATFORM = no;
          OXP_EC = no; # OneXPlayer/AOKZOE embedded controller
          PANASONIC_LAPTOP = no;
          PCENGINES_APU2 = no;
          PORTWELL_EC = no;
          REDMI_WMI = no;
          SAMSUNG_GALAXYBOOK = no;
          SAMSUNG_LAPTOP = no;
          SAMSUNG_Q10 = no;
          SEL3350_PLATFORM = no;
          SIEMENS_SIMATIC_IPC = no;
          SILICOM_PLATFORM = no;
          SONY_LAPTOP = no;
          SYSTEM76_ACPI = no;
          THINKPAD_ACPI = no; # IBM/Lenovo Thinkpad Stuff
          THINKPAD_LMI = no; # Lenovo WMI system management driver
          TOPSTAR_LAPTOP = no;
          TOSHIBA_BT_RFKILL = no;
          TOSHIBA_HAPS = no; # Toshiba Hard Drive Protection Thing
          TOSHIBA_WMI = no;
          TUXEDO_NB04_WMI_AB = no;
          WINMATE_FM07_KEYS = no;
          WIRELESS_HOTKEY = no; # Wireless button on AMD/HP/Xiaomi Laptops
          XIAOMI_WMI = no;
          X86_ANDROID_TABLETS = no;
          X86_PLATFORM_DRIVERS_DELL = mkForce no;
          X86_PLATFORM_DRIVERS_HP = mkForce no;
          X86_PLATFORM_DRIVERS_UNIWILL = no;
          YOGABOOK = no;
          YT2_1380 = no; # Lenovo Yoga Tablet 2 1380 fast charging protocol

          # Miscellaneous Drivers
          ACCESSIBILITY = mkForce no;
          BCMA = no; # Broadcom Specific AMBA
          CHROME_PLATFORMS = mkForce no;
          COMEDI = no; # Scientific Data Collection Hardware
          FIREWIRE = no;
          FIREWIRE_NOSY = no; # Firewire Probe Thing?
          FPGA = no;
          FSI = no;
          FUSION = mkForce no; # Fusion Message Passing Technology
          GOLDFISH = no; # Goldfish Virtual Platform
          GPIB = no; # General Purpose Interface Bus
          GREYBUS = no;
          HAMRADIO = lib.mkForce no; # Ham Radio Support
          HSI = no; # High-spped synchronous Serial Interface
          HSI_BOARDINFO = no;
          HTE = no;
          IIO = no; # Industrial I/O
          INFINIBAND = mkForce no; # Before ethernet was fast or something
          INTERCONNECT = no;
          IPACK_BUS = no; # IndustryPack Bus
          LIRC = mkForce no;
          MCB = no;
          MELLANOX_PLATFORM = no; # Mellanox Drivers
          MEMSTICK = no; # Sony Memory Stick
          MOST = no; # Media Oriented Systems Transport
          NTB = no;
          OF = mkForce no; # Open Firmware/Device Trees - We use ACPI here
          PARPORT = no; # Parallel Port - which we don't have
          PCCARD = no; # Predecessor to PCMCIA
          # PECI = no;
          # PPS = no; # Pulse Per Second (GPS-related)
          RAS = mkForce no;
          REGULATOR = mkForce no; # Generic Voltage/Current Regulators - done via ACPI?
          REMOTEPROC = no;
          RESET_CONTROLLER = no; # GPIO and similar Reset Controllers
          # SSB = no; # Sonics Silicon Backplane - Why dependency???
          SIOX = no;
          SLIMBUS = no;
          # W1 = no;

          STAGING = mkForce no;

          # Misc Drivers (Individual)
          AD525X_DPOT = no; # Analog Devices Digital Potentiometers
          ALTERA_STAPL = no; # Altera Firmware Download thing
          APDS9802ALS = no; # Ambient Light Sensor
          BCM_VK = no; # Broadcom VK Accelerators
          C2PORT = no; # Silicon Labs C2 Port
          # CB710_CORE = no; # PCI ENE CB710/720 Flash Memory card reader
          DS1682 = no; # Elapsed Time Recorder with Alarm - Whatever that is
          DUMMY_IRQ = no;
          DW_XDATA_PCIE = no; # Synopsys DesignWare PCIe traffic generator IP
          GENWQE = no; # IBM GenWQE Accelerators
          HMC6352 = no; # A compass? huh
          HP_ILO = no; # Used in HP ProLiant servers
          IBM_ASM = no; # IBM RSA service processor
          ICS932S401 = no; # A clock control chip
          ISL29003 = no; # Ambient Light Sensor
          ISL29020 = no; # Ambient Light Sensor
          KEBA_CP500 = no; # KEBA CP500 System FPGA
          MISC_ALCOR_PCI = no; # Alcor Micro PCI express card readers
          MISC_RTSX_PCI = no; # Realtek PCI express card readers
          MUX_ADG792A = no; # Multiplexer
          NSM = no; # Nitro Security Module - AWS EC2
          PCI_ENDPOINT_TEST = no;
          PHANTOM = no; # Sensable PHANToM
          SENSORS_APDS990X = no; # Ambient Light Sensor + Proximity Sensor
          SENSORS_BH1770 = no; # Ambient Light Sensor + Proximity Sensor
          SENSORS_LIS3_I2C = no; # Accelerometer
          SENSORS_LIS3LV02D = no; # Accelerometer - but 3 axis digital
          SENSORS_TSL2550 = no; # Ambient Light Sensor
          TI_FPC202 = no; # Texas Instruments FPC202 Dual Port Controller
          VMWARE_VMCI = no; # VMWare Virtual Machine Communication Interface
          XILINX_SDFEC = no; # Xilinx Soft Decision Forward Error Correction Driver

          # Cleanup eventually
          MEDIA_ATTACH = mkForce no;
          DVB_DYNAMIC_MINORS = mkForce no;
          USB_AIRSPY = no;
          USB_HACKRF = no;
          USB_MSI2500 = no;
          MEDIA_PLATFORM_DRIVERS = no;
          VIDEO_TVEEPROM = no;
          DVB_B2C2_FLEXCOP = no;
          SMS_SIANO_MDTV = no;
          CYPRESS_FIRMWARE = no;

          PCIE_CADENCE_PLAT_HOST = no;
          PCIE_MICROCHIP_HOST = no;

          SMPRO_ERRMON = no;
          SMPRO_MISC = no;
          HI6421V600_IRQ = no;
          VMWARE_BALLOON = no;
          LATTICE_ECP3_CONFIG = no;
          HISI_HIKEY_USB = no;
          VCPU_STALL_DETECTOR = no;
          TPS6594_ESM = no;
          TPS6594_PFSM = no;
          MCHP_LAN966X_PCI = no;
          GP_PCI1XXXX = no;
          MISC_RP1 = no;
          SCSI_PPA = no;
          SCSI_IMM = no;
          MUX_ADGS1408 = no;
          MUX_GPIO = no;
          MUX_MMIO = no;
          DWC_PCIE_PMU = no;
          RPMSG_QCOM_GLINK_RPM = no;

          SND_SOC_MIKROE_PROTO = no;

          RTL8723BS = no;

          #
          PHYLIB_LEDS = no;
          QCA807X_PHY = no;

          MDIO_BITBANG = no;
          MDIO_BCM_UNIMAC = no;
          MDIO_HISI_FEMAC = no;
          MDIO_MVUSB = no;
          MDIO_MSCC_MIIM = no;
          MDIO_REGMAP = mkForce no;
          MDIO_THUNDER = no;

          PCS_XPCS = no;
          PCS_LYNX = no;
          PLIP = no;

          FUJITSU_ES = no;

          SERIAL_SIFIVE = no;
          SERIAL_XILINX_PS_UART = no;
          SERIAL_CONEXANT_DIGICOLOR = no;
          SERIAL_MEN_Z135 = no;

          SERIAL_NONSTANDARD = no;
          N_GSM = no;
          NOZOMI = no;

          # LP_CONSOLE is not set
          PPDEV = no;

          IPMB_DEVICE_INTERFACE = no;
          HW_RANDOM_CCTRNG = no;
          APPLICOM = no;
          TELCLOCK = no;
          XILLYBUS = no;
          XILLYUSB = no;

          ZL3073X = no;
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
