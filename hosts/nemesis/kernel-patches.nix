{
  lib,
  patchSrc,
  version,
}:
let
  inherit (lib) mkForce;
in
[
  {
    ############################################
    # linux-surface patches
    ############################################
    name = "microsoft-surface-patches-linux-${version}";
    patch = ./surface-kernel-patches-v7.0.patch;
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

  ############################################
  # Config to reduce extra module builds
  ############################################
  # Limit what CPU/GPU stuff is built
  {
    name = "cpu-graphics-limit-support";
    patch = null;
    structuredExtraConfig = with lib.kernel; {

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

      # CPU Support
      CPU_SUP_AMD = no;
      X86_EXTENDED_PLATFORM = no;
      AMD_IOMMU_V2 = no;
      INTEL_SKL_INT3472 = mkForce no; # Skips a compilation failure introduced in a patch

      # Display Interface Bridges
      DRM_I2C_NXP_TDA998X = no;
      DRM_ANALOGIX_ANX78XX = no;

    };
  }
  # These are modules that I really will likely not need
  {
    name = "98-dont-build-unused-drivers";
    patch = null;
    structuredExtraConfig = with lib.kernel; {
      GOOGLE_FIRMWARE = lib.mkForce no;
      # General modules I don't use
      HAMRADIO = lib.mkForce no;
      PCCARD = no;
      MOXTET = no;
      IIO = no;

      PCIE_CADENCE_PLAT_HOST = no;
      PCIE_MICROCHIP_HOST = no;

      SENSORS_LIS3LV02D = no;
      AD525X_DPOT = no;

      DUMMY_IRQ = no;
      IBM_ASM = no;
      PHANTOM = no;
      ICS932S401 = no;
      SMPRO_ERRMON = no;
      SMPRO_MISC = no;
      HI6421V600_IRQ = no;
      HP_ILO = no;
      APDS9802ALS = no;
      ISL29003 = no;
      ISL29020 = no;
      SENSORS_TSL2550 = no;
      SENSORS_BH1770 = no;
      SENSORS_APDS990X = no;
      HMC6352 = no;
      DS1682 = no;
      VMWARE_BALLOON = no;
      LATTICE_ECP3_CONFIG = no;
      DW_XDATA_PCIE = no;
      PCI_ENDPOINT_TEST = no;
      XILINX_SDFEC = no;
      HISI_HIKEY_USB = no;
      OPEN_DICE = no;
      VCPU_STALL_DETECTOR = no;
      TPS6594_ESM = no;
      TPS6594_PFSM = no;
      NSM = no;
      MCHP_LAN966X_PCI = no;
      C2PORT = no;
      C2PORT_DURAMAR_2150 = no;
      SENSORS_LIS3_I2C = no;
      GENWQE = no;
      BCM_VK = no;
      MISC_ALCOR_PCI = no;
      MISC_RTSX_PCI = no;
      GP_PCI1XXXX = no;
      KEBA_CP500 = no;
      MISC_RP1 = no;
      SCSI_PPA = no;
      SCSI_IMM = no;

      PATA_TIMINGS = no;

      #
      # PATA SFF controllers with BMDMA
      #
      PATA_ALI = no;
      PATA_AMD = no;
      PATA_ARTOP = no;
      PATA_ATIIXP = no;
      PATA_ATP867X = no;
      PATA_CMD64X = no;
      PATA_CYPRESS = no;
      PATA_EFAR = no;
      PATA_HPT366 = no;
      PATA_HPT37X = no;
      PATA_HPT3X2N = no;
      PATA_HPT3X3 = no;
      # PATA_HPT3X3_DMA is not set
      PATA_IT8213 = no;
      PATA_IT821X = no;
      PATA_JMICRON = no;
      # PATA_MARVELL = no;
      PATA_NETCELL = no;
      PATA_NINJA32 = no;
      PATA_NS87415 = no;
      PATA_OLDPIIX = no;
      PATA_OPTIDMA = no;
      PATA_PDC2027X = no;
      PATA_PDC_OLD = no;
      PATA_RADISYS = no;
      PATA_RDC = no;
      PATA_SCH = no;
      PATA_SERVERWORKS = no;
      PATA_SIL680 = no;
      PATA_SIS = no;
      PATA_TOSHIBA = no;
      PATA_TRIFLEX = no;
      PATA_VIA = no;
      PATA_WINBOND = no;

      #
      # PIO-only SFF controllers
      #
      PATA_CMD640_PCI = no;
      PATA_MPIIX = no;
      PATA_NS87410 = no;
      PATA_OPTI = no;
      PATA_PCMCIA = no;
      PATA_PLATFORM = no;
      PATA_OF_PLATFORM = no;
      PATA_RZ1000 = no;
      PATA_PARPORT = no;

      #
      # Generic fallback / legacy drivers
      #
      PATA_ACPI = no;
      PATA_LEGACY = no;

      SBP_TARGET = no;

      # FUSION = no;
      # FUSION_SPI = no;
      # FUSION_FC = no;
      # FUSION_SAS = no;
      # FUSION_CTL = no;
      # FUSION_LAN = no;

      FIREWIRE = no;
      FIREWIRE_NOSY = no;

      MACINTOSH_DRIVERS = no;
      MAC_EMUMOUSEBTN = no;

      NTB_NETDEV = no;

      SUNGEM_PHY = no;
      ARCNET = no;
      B53 = no;

      NET_DSA_BCM_SF2 = no;
      NET_DSA_LOOP = no;
      NET_DSA_HIRSCHMANN_HELLCREEK = no;
      NET_DSA_LANTIQ_GSWIP = no;
      NET_DSA_MT7530 = no;
      NET_DSA_MV88E6060 = no;
      NET_DSA_MICROCHIP_KSZ_COMMON = no;
      NET_DSA_MV88E6XXX = no;
      NET_DSA_AR9331 = no;
      NET_DSA_QCA8K = no;
      NET_DSA_SJA1105 = no;
      NET_DSA_XRS700X = no;
      NET_DSA_REALTEK = no;
      NET_DSA_KS8995 = no;
      NET_DSA_VITESSE_VSC73XX = no;
      NET_DSA_VITESSE_VSC73XX_PLATFORM = no;

      NET_VENDOR_3COM = no;
      NET_VENDOR_ADAPTEC = no;
      NET_VENDOR_AGERE = no;
      NET_VENDOR_ALACRITECH = no;
      NET_VENDOR_ALTEON = no;
      NET_VENDOR_AMAZON = no;
      NET_VENDOR_AMD = no;
      NET_VENDOR_AQUANTIA = no;
      NET_VENDOR_ARC = no;
      NET_VENDOR_ASIX = no;
      NET_VENDOR_ATHEROS = no;
      NET_VENDOR_BROADCOM = no;
      NET_VENDOR_CADENCE = no;
      NET_VENDOR_CAVIUM = no;
      NET_VENDOR_CORTINA = no;
      NET_VENDOR_DAVICOM = no;
      NET_VENDOR_DEC = no;
      NET_VENDOR_ENGLEDER = no;
      NET_VENDOR_EZCHIP = no;
      NET_VENDOR_FUNGIBLE = no;
      NET_VENDOR_GOOGLE = no;
      NET_VENDOR_HISILICON = no;
      NET_VENDOR_HUAWEI = no;
      NET_VENDOR_I825XX = no;
      NET_VENDOR_ADI = no;
      NET_VENDOR_LITEX = no;
      NET_VENDOR_MARVELL = no;
      NET_VENDOR_META = no;
      NET_VENDOR_MICREL = no;
      NET_VENDOR_MICROCHIP = no;
      NET_VENDOR_MICROSEMI = no;
      NET_VENDOR_MICROSOFT = no;
      NET_VENDOR_MYRI = no;
      NET_VENDOR_NI = no;
      NET_VENDOR_NATSEMI = no;
      NET_VENDOR_NETRONOME = no;
      NET_VENDOR_8390 = no;
      NET_VENDOR_NVIDIA = no;
      NET_VENDOR_OKI = no;
      NET_VENDOR_PACKET_ENGINES = no;
      NET_VENDOR_PENSANDO = no;
      NET_VENDOR_QLOGIC = no;
      NET_VENDOR_BROCADE = no;
      NET_VENDOR_QUALCOMM = no;
      NET_VENDOR_RDC = no;
      NET_VENDOR_REALTEK = no;
      NET_VENDOR_RENESAS = no;
      NET_VENDOR_ROCKER = no;
      NET_VENDOR_SAMSUNG = no;
      NET_VENDOR_SEEQ = no;
      NET_VENDOR_SILAN = no;
      NET_VENDOR_SIS = no;
      NET_VENDOR_SOLARFLARE = no;
      NET_VENDOR_SMSC = no;
      NET_VENDOR_SOCIONEXT = no;
      NET_VENDOR_STMICRO = no;
      NET_VENDOR_SUN = no;
      NET_VENDOR_SYNOPSYS = no;
      NET_VENDOR_TEHUTI = no;
      NET_VENDOR_TI = no;
      NET_VENDOR_VERTEXCOM = no;
      NET_VENDOR_VIA = no;
      NET_VENDOR_WANGXUN = no;
      NET_VENDOR_WIZNET = no;
      NET_VENDOR_XILINX = no;
      HIPPI = mkForce no;

      PHYLIB_LEDS = no;
      QCA807X_PHY = no;

      CAN_NETLINK = no;


      MDIO_BITBANG = no;
      MDIO_BCM_UNIMAC = no;
      MDIO_HISI_FEMAC = no;
      MDIO_MVUSB = no;
      MDIO_MSCC_MIIM = no;
      MDIO_OCTEON = no;
      MDIO_IPQ4019 = no;
      MDIO_IPQ8064 = no;
      MDIO_REGMAP = mkForce no;
      MDIO_THUNDER = no;

      PCS_XPCS = no;
      PCS_LYNX = no;
      PLIP = no;

      WLAN_VENDOR_ADMTEK = no;
      WLAN_VENDOR_ATH = no;
      WLAN_VENDOR_ATMEL = no;
      WLAN_VENDOR_BROADCOM = no;
      WLAN_VENDOR_INTERSIL = no;
      WLAN_VENDOR_MARVELL = no;
      WLAN_VENDOR_MEDIATEK = no;
      WLAN_VENDOR_MICROCHIP = no;
      WLAN_VENDOR_PURELIFI = no;
      WLAN_VENDOR_RALINK = no;
      WLAN_VENDOR_REALTEK = no;
      WLAN_VENDOR_RSI = no;
      WLAN_VENDOR_SILABS = no;
      WLAN_VENDOR_ST = no;
      WLAN_VENDOR_TI = no;
      WLAN_VENDOR_ZYDAS = no;
      WLAN_VENDOR_QUANTENNA = no;

      IPW2100 = no;
      IPW2200 = no;
      LIBIPW = no;
      IWLEGACY = no;
      IWL4965 = no;
      IWL3945 = no;

      RT2800USB_RT53XX = mkForce no;
      RT2800USB_RT55XX = mkForce no;
      RTL8XXXU_UNTESTED = mkForce no;
      RTW88 = mkForce no;
      RTW89 = mkForce no;

      WAN = mkForce no;
      PCI200SYN = no;
      WANXL = no;
      PC300TOO = no;
      FARSYNC = no;
      LAPBETHER = no;

      FUJITSU_ES = no;

      HYPERV_NET = no;

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

      SERIAL_SIFIVE = no;
      SERIAL_XILINX_PS_UART = no;
      SERIAL_CONEXANT_DIGICOLOR = no;
      SERIAL_MEN_Z135 = no;

      SERIAL_NONSTANDARD = no;
      MOXA_INTELLIO = no;
      MOXA_SMARTIO = no;
      N_HDLC = no;
      IPWIRELESS = no;
      N_GSM = no;
      NOZOMI = no;

      PRINTER = no;
      # LP_CONSOLE is not set
      PPDEV = no;

      IPMB_DEVICE_INTERFACE = no;
      HW_RANDOM_CCTRNG = no;
      APPLICOM = no;
      TELCLOCK = no;
      XILLYBUS = no;
      XILLYUSB = no;

      HSI = no;
      HSI_BOARDINFO = no;

      ZL3073X = no;
      # SSB = no;
      BCMA = no;

      RC_CORE = mkForce no;

      VIDEO_TUNER = no;
      MEDIA_CONTROLLER_DVB = no;
      VIDEO_USBTV = no;
      RADIO_ADAPTERS = no;
      MEDIA_ANALOG_TV_SUPPORT = mkForce no;
      MEDIA_COMMON_OPTIONS = no;
      MEDIA_DIGITAL_TV_SUPPORT = mkForce no;
      MEDIA_PCI_SUPPORT = mkForce no;
      MEDIA_RADIO_SUPPORT = no;
      MEDIA_SDR_SUPPORT = no;

      SND_SOC_MIKROE_PROTO = no;

      MEMSTICK = no;
      ACCESSIBILITY = mkForce no; # Set in nixpkgs
      GREYBUS = no;
      COMEDI = no;
      STAGING = mkForce no;
      RTL8723BS = no;

      STAGING_MEDIA = mkForce no;


      XIL_AXIS_FIFO = no;
      # VME_BUS is not set
      GPIB = no;
      CHROME_PLATFORMS = mkForce no;

      WILCO_EC = no;

      IDEAPAD_LAPTOP = no;
      LENOVO_YMC = no;
      MSI_LAPTOP = no;
      SAMSUNG_GALAXYBOOK = no;
      SAMSUNG_LAPTOP = no;
      SAMSUNG_Q10 = no;
      ACPI_TOSHIBA = no;


      WPCM450_SOC = no;
      # WPCM450_SOC is not set

      #
      # Qualcomm SoC drivers
      #
      QCOM_PMIC_PDCHARGER_ULOG = no;
      QCOM_PMIC_GLINK = no;
      QCOM_PBS = no;

      NTB = no;
      FPGA = no;
      FSI = no;
      MOST = no;
      PECI = no;
      PECI_CPU = no;
      SIOX = no;
      SIOX_BUS_GPIO = no;
      SLIMBUS = no;
      MUX_ADG792A = no;
      MUX_ADGS1408 = no;
      MUX_GPIO = no;
      MUX_MMIO = no;
    };
  }
]
