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
  # These are modules that I really will likely not need
  {
    name = "98-dont-build-unused-drivers";
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

      # Display Interface Bridges
      DRM_I2C_NXP_TDA998X = no;
      DRM_ANALOGIX_ANX78XX = no;
      GOOGLE_FIRMWARE = lib.mkForce no;

      # General modules I don't use
      HAMRADIO = lib.mkForce no;
      PCCARD = no;
      MOXTET = no;
      IIO = no;
      PATA_ACPI = no;
      PATA_LEGACY = no;
      FIREWIRE = no;
      FIREWIRE_NOSY = no;

      MEMSTICK = no;
      ACCESSIBILITY = mkForce no; # Set in nixpkgs
      GREYBUS = no;
      COMEDI = no;
      STAGING = mkForce no;
      CHROME_PLATFORMS = mkForce no;
      INFINIBAND = mkForce no;
      FUSION = mkForce no;
      LIRC = mkForce no;

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

      SBP_TARGET = no;

      PHYLIB_LEDS = no;
      QCA807X_PHY = no;

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

      IPW2100 = no;
      IPW2200 = no;
      IWL4965 = no;
      IWL3945 = no;

      FUJITSU_ES = no;

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

      SERIAL_SIFIVE = no;
      SERIAL_XILINX_PS_UART = no;
      SERIAL_CONEXANT_DIGICOLOR = no;
      SERIAL_MEN_Z135 = no;

      SERIAL_NONSTANDARD = no;
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

      # TV tuners and things like what linux supported all this?
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
      MEDIA_TEST_SUPPORT = no;
      USB_GSPCA = no;
      MEDIA_TUNER = no;

      TOUCHSCREEN_SUR40 = no;

      DVB_AS102 = no;
      DVB_B2C2_FLEXCOP_USB = no;
      # DVB_B2C2_FLEXCOP_USB_DEBUG is not set
      DVB_USB_V2 = no;
      DVB_USB_AF9015 = no;
      DVB_USB_AF9035 = no;
      DVB_USB_ANYSEE = no;
      DVB_USB_AU6610 = no;
      DVB_USB_AZ6007 = no;
      DVB_USB_CE6230 = no;
      DVB_USB_DVBSKY = no;
      DVB_USB_EC168 = no;
      DVB_USB_GL861 = no;
      DVB_USB_MXL111SF = no;
      DVB_USB_RTL28XXU = no;
      DVB_USB_ZD1301 = no;
      SMS_USB_DRV = no;
      DVB_TTUSB_BUDGET = no;
      DVB_TTUSB_DEC = no;

      MEDIA_TUNER_E4000 = no;
      MEDIA_TUNER_FC0011 = no;
      MEDIA_TUNER_FC0012 = no;
      MEDIA_TUNER_FC0013 = no;
      MEDIA_TUNER_FC2580 = no;
      MEDIA_TUNER_IT913X = no;
      MEDIA_TUNER_M88RS6000T = no;
      MEDIA_TUNER_MAX2165 = no;
      MEDIA_TUNER_MC44S803 = no;
      MEDIA_TUNER_MSI001 = no;
      MEDIA_TUNER_MT2060 = no;
      MEDIA_TUNER_MT2063 = no;
      MEDIA_TUNER_MT20XX = no;
      MEDIA_TUNER_MT2131 = no;
      MEDIA_TUNER_MT2266 = no;
      MEDIA_TUNER_MXL301RF = no;
      MEDIA_TUNER_MXL5005S = no;
      MEDIA_TUNER_MXL5007T = no;
      MEDIA_TUNER_QM1D1B0004 = no;
      MEDIA_TUNER_QM1D1C0042 = no;
      MEDIA_TUNER_QT1010 = no;
      MEDIA_TUNER_R820T = no;
      MEDIA_TUNER_SI2157 = no;
      MEDIA_TUNER_SIMPLE = no;
      MEDIA_TUNER_TDA18212 = no;
      MEDIA_TUNER_TDA18218 = no;
      MEDIA_TUNER_TDA18250 = no;
      MEDIA_TUNER_TDA18271 = no;
      MEDIA_TUNER_TDA827X = no;
      MEDIA_TUNER_TDA8290 = no;
      MEDIA_TUNER_TDA9887 = no;
      MEDIA_TUNER_TEA5761 = no;
      MEDIA_TUNER_TEA5767 = no;
      MEDIA_TUNER_TUA9001 = no;
      MEDIA_TUNER_XC2028 = no;
      MEDIA_TUNER_XC4000 = no;
      MEDIA_TUNER_XC5000 = no;
      # end of Customize TV tuners

      #
      # Customise DVB Frontends
      #

      #
      # Multistandard (satellite) frontends
      #
      DVB_M88DS3103 = no;
      DVB_MXL5XX = no;
      DVB_STB0899 = no;
      DVB_STB6100 = no;
      DVB_STV090x = no;
      DVB_STV0910 = no;
      DVB_STV6110x = no;
      DVB_STV6111 = no;

      #
      # Multistandard (cable + terrestrial) frontends
      #
      DVB_DRXK = no;
      DVB_MN88472 = no;
      DVB_MN88473 = no;
      DVB_SI2165 = no;
      DVB_TDA18271C2DD = no;

      #
      # DVB-S (satellite) frontends
      #
      DVB_CX24110 = no;
      DVB_CX24116 = no;
      DVB_CX24117 = no;
      DVB_CX24120 = no;
      DVB_CX24123 = no;
      DVB_DS3000 = no;
      DVB_MB86A16 = no;
      DVB_MT312 = no;
      DVB_S5H1420 = no;
      DVB_SI21XX = no;
      DVB_STB6000 = no;
      DVB_STV0288 = no;
      DVB_STV0299 = no;
      DVB_STV0900 = no;
      DVB_STV6110 = no;
      DVB_TDA10071 = no;
      DVB_TDA10086 = no;
      DVB_TDA8083 = no;
      DVB_TDA8261 = no;
      DVB_TDA826X = no;
      DVB_TS2020 = no;
      DVB_TUA6100 = no;
      DVB_TUNER_CX24113 = no;
      DVB_TUNER_ITD1000 = no;
      DVB_VES1X93 = no;
      DVB_ZL10036 = no;
      DVB_ZL10039 = no;

      #
      # DVB-T (terrestrial) frontends
      #
      DVB_AF9013 = no;
      DVB_AS102_FE = no;
      DVB_CX22700 = no;
      DVB_CX22702 = no;
      DVB_CXD2820R = no;
      DVB_CXD2841ER = no;
      DVB_DIB3000MB = no;
      DVB_DIB3000MC = no;
      DVB_DIB7000M = no;
      DVB_DIB7000P = no;
      DVB_DIB9000 = no;
      DVB_DRXD = no;
      DVB_EC100 = no;
      DVB_L64781 = no;
      DVB_MT352 = no;
      DVB_NXT6000 = no;
      DVB_RTL2830 = no;
      DVB_RTL2832 = no;
      DVB_RTL2832_SDR = no;
      DVB_S5H1432 = no;
      DVB_SI2168 = no;
      DVB_SP887X = no;
      DVB_STV0367 = no;
      DVB_TDA10048 = no;
      DVB_TDA1004X = no;
      DVB_ZD1301_DEMOD = no;
      DVB_ZL10353 = no;
      DVB_CXD2880 = no;

      #
      # DVB-C (cable) frontends
      #
      DVB_STV0297 = no;
      DVB_TDA10021 = no;
      DVB_TDA10023 = no;
      DVB_VES1820 = no;

      #
      # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
      #
      DVB_AU8522 = no;
      DVB_AU8522_DTV = no;
      DVB_AU8522_V4L = no;
      DVB_BCM3510 = no;
      DVB_LG2160 = no;
      DVB_LGDT3305 = no;
      DVB_LGDT3306A = no;
      DVB_LGDT330X = no;
      DVB_MXL692 = no;
      DVB_NXT200X = no;
      DVB_OR51132 = no;
      DVB_OR51211 = no;
      DVB_S5H1409 = no;
      DVB_S5H1411 = no;

      #
      # ISDB-T (terrestrial) frontends
      #
      DVB_DIB8000 = no;
      DVB_MB86A20S = no;
      DVB_S921 = no;

      #
      # ISDB-S (satellite) & ISDB-T (terrestrial) frontends
      #
      DVB_MN88443X = no;
      DVB_TC90522 = no;

      #
      # Digital terrestrial only tuners/PLL
      #
      DVB_PLL = no;
      DVB_TUNER_DIB0070 = no;
      DVB_TUNER_DIB0090 = no;

      #
      # SEC control devices for DVB-S
      #
      DVB_A8293 = no;
      DVB_AF9033 = no;
      DVB_ASCOT2E = no;
      DVB_ATBM8830 = no;
      DVB_HELENE = no;
      DVB_HORUS3A = no;
      DVB_ISL6405 = no;
      DVB_ISL6421 = no;
      DVB_ISL6423 = no;
      DVB_IX2505V = no;
      DVB_LGS8GL5 = no;
      DVB_LGS8GXX = no;
      DVB_LNBH25 = no;
      DVB_LNBH29 = no;
      DVB_LNBP21 = no;
      DVB_LNBP22 = no;
      DVB_M88RS2000 = no;
      DVB_TDA665x = no;
      DVB_DRX39XYJ = no;

      #
      # Common Interface (EN50221) controller drivers
      #
      DVB_CXD2099 = no;
      DVB_SP2 = no;
      # end of Customise DVB Frontends

      #
      # Tools to develop new frontends
      #
      DVB_DUMMY_FE = no;
      # end of Media ancillary drivers
      SND_SOC_MIKROE_PROTO = no;

      RTL8723BS = no;

      GPIB = no;

      IDEAPAD_LAPTOP = no;
      MSI_LAPTOP = no;
      SAMSUNG_GALAXYBOOK = no;
      SAMSUNG_LAPTOP = no;
      SAMSUNG_Q10 = no;
      ACPI_TOSHIBA = no;

      WPCM450_SOC = no;
      QCOM_PMIC_PDCHARGER_ULOG = no;
      QCOM_PMIC_GLINK = no;
      QCOM_PBS = no;

      NTB = no;
      FPGA = no;
      FSI = no;
      MOST = no;
      PECI = no;
      SIOX = no;
      SLIMBUS = no;
      MUX_ADG792A = no;
      MUX_ADGS1408 = no;
      MUX_GPIO = no;
      MUX_MMIO = no;
    };
  }
]
