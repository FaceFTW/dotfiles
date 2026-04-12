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
    patch = null;
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
  {
    name = "ms-surface/0001-secureboot";
    patch = patchSrc + "/0001-secureboot.patch";
  }
  {
    name = "ms-surface/0002-surface3";
    patch = patchSrc + "/0002-surface3.patch";
  }
  {
    name = "ms-surface/0003-mwifiex";
    patch = patchSrc + "/0003-mwifiex.patch";
  }
  {
    name = "ms-surface/0004-ath10k";
    patch = patchSrc + "/0004-ath10k.patch";
  }
  {
    name = "ms-surface/0005-ipts";
    patch = patchSrc + "/0005-ipts.patch";
  }
  {
    name = "ms-surface/0006-ithc";
    patch = patchSrc + "/0006-ithc.patch";
  }
  {
    name = "ms-surface/0007-surface-sam";
    patch = patchSrc + "/0007-surface-sam.patch";
  }
  {
    name = "ms-surface/0008-surface-sam-over-hid";
    patch = patchSrc + "/0008-surface-sam-over-hid.patch";
  }
  {
    name = "ms-surface/0009-surface-button";
    patch = patchSrc + "/0009-surface-button.patch";
  }
  {
    name = "ms-surface/0010-surface-typecover";
    patch = patchSrc + "/0010-surface-typecover.patch";
  }
  {
    name = "ms-surface/0011-surface-shutdown";
    patch = patchSrc + "/0011-surface-shutdown.patch";
  }
  {
    name = "ms-surface/0012-surface-gpe";
    patch = patchSrc + "/0012-surface-gpe.patch";
  }
  {
    name = "ms-surface/0013-cameras";
    patch = patchSrc + "/0013-cameras.patch";
  }
  {
    name = "ms-surface/0014-amd-gpio";
    patch = patchSrc + "/0014-amd-gpio.patch";
  }
  {
    name = "ms-surface/0015-rtc";
    patch = patchSrc + "/0015-rtc.patch";
  }
  {
    name = "ms-surface/0016-hid-surface";
    patch = patchSrc + "/0016-hid-surface.patch";
  }
  # {
  #   name = "ms-surface/0017-powercap";
  #   patch = patchSrc + "/0017-powercap.patch";
  # }

  ############################################
  # Config to reduce extra module builds
  ############################################
  # This is an Intel System, skip building AMD things
  {
    name = "97-skip-amd-support";
    patch = null;
    structuredExtraConfig = with lib.kernel; {
      CPU_SUP_AMD = no;
      AGP_AMD = no;
      AGP_AMD64 = no;
      COFNIG_X86_AMD_PSTATE = no;
      AMD_IOMMU_V2 = no;
      DRM_AMDGPU = no;
    };
  }

  # These are modules that I really will likely not need
  {
    name = "98-dont-build-unused-drivers";
    patch = null;
    structuredExtraConfig = with lib.kernel; {
      GOOGLE_FIRMWARE = lib.mkForce no;
      GOOGLE_SMI = no;
      GOOGLE_CBMEM = no;
      GOOGLE_COREBOOT_TABLE = no;
      GOOGLE_MEMCONSOLE = no;
      GOOGLE_MEMCONSOLE_X86_LEGACY = no;
      GOOGLE_FRAMEBUFFER_COREBOOT = no;
      GOOGLE_MEMCONSOLE_COREBOOT = no;
      GOOGLE_VPD = no;

      # General modules I don't use
      HAMRADIO = lib.mkForce no;
      PCCARD = no;
      PCMCIA = no;
      PCMCIA_LOAD_CIS = no;
      CARDBUS = no;

      YENTA = no;
      YENTA_O2 = no;
      YENTA_RICOH = no;
      YENTA_TI = no;
      YENTA_ENE_TUNE = no;
      YENTA_TOSHIBA = no;
      PD6729 = no;
      I82092 = no;
      PCCARD_NONSTATIC = no;

      MOXTET = no;

      PCIE_CADENCE_PLAT_HOST = no;
      PCIE_PLDA_HOST = no;
      PCIE_MICROCHIP_HOST = no;

      SENSORS_LIS3LV02D = no;
      AD525X_DPOT = no;
      AD525X_DPOT_I2C = no;
      AD525X_DPOT_SPI = no;

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
      KEBA_LAN9252 = no;
      MISC_RP1 = no;
      SCSI_PPA = no;
      SCSI_IMM = no;
      QEDI = no;
      QEDF = no;
      SCSI_LOWLEVEL_PCMCIA = mkForce no;
      PCMCIA_AHA152X = no;
      PCMCIA_FDOMAIN = no;
      PCMCIA_QLOGIC = no;
      PCMCIA_SYM53C500 = no;
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
      PATA_MARVELL = no;
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
      # Parallel IDE protocol modules
      #
      PATA_PARPORT_ATEN = no;
      PATA_PARPORT_BPCK = no;
      PATA_PARPORT_BPCK6 = no;
      PATA_PARPORT_COMM = no;
      PATA_PARPORT_DSTR = no;
      PATA_PARPORT_FIT2 = no;
      PATA_PARPORT_FIT3 = no;
      PATA_PARPORT_EPAT = no;
      # PATA_PARPORT_EPATC8 is not set
      PATA_PARPORT_EPIA = no;
      PATA_PARPORT_FRIQ = no;
      PATA_PARPORT_FRPW = no;
      PATA_PARPORT_KBIC = no;
      PATA_PARPORT_KTTI = no;
      PATA_PARPORT_ON20 = no;
      PATA_PARPORT_ON26 = no;

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
      FIREWIRE_OHCI = no;
      FIREWIRE_SBP2 = no;
      FIREWIRE_NET = no;
      FIREWIRE_NOSY = no;

      MACINTOSH_DRIVERS = no;
      MAC_EMUMOUSEBTN = no;

      NTB_NETDEV = no;

      SUNGEM_PHY = no;
      ARCNET = no;
      ARCNET_1201 = no;
      ARCNET_1051 = no;
      ARCNET_RAW = no;
      ARCNET_CAP = no;
      ARCNET_COM90xx = no;
      ARCNET_COM90xxIO = no;
      ARCNET_RIM_I = no;
      ARCNET_COM20020 = no;
      ARCNET_COM20020_PCI = no;
      ARCNET_COM20020_CS = no;

      B53 = no;
      B53_SPI_DRIVER = no;
      B53_MDIO_DRIVER = no;
      B53_MMAP_DRIVER = no;
      B53_SRAB_DRIVER = no;
      B53_SERDES = no;
      NET_DSA_BCM_SF2 = no;
      NET_DSA_LOOP = no;
      NET_DSA_HIRSCHMANN_HELLCREEK = no;
      NET_DSA_LANTIQ_GSWIP = no;
      NET_DSA_MT7530 = no;
      NET_DSA_MT7530_MDIO = no;
      NET_DSA_MT7530_MMIO = no;
      NET_DSA_MV88E6060 = no;
      NET_DSA_MICROCHIP_KSZ_COMMON = no;
      NET_DSA_MICROCHIP_KSZ9477_I2C = no;
      NET_DSA_MICROCHIP_KSZ_SPI = no;
      # NET_DSA_MICROCHIP_KSZ_PTP is not set
      NET_DSA_MICROCHIP_KSZ8863_SMI = no;
      NET_DSA_MV88E6XXX = no;
      # NET_DSA_MV88E6XXX_PTP is not set
      NET_DSA_MV88E6XXX_LEDS = no;
      NET_DSA_MSCC_FELIX_DSA_LIB = no;
      NET_DSA_MSCC_OCELOT_EXT = no;
      NET_DSA_MSCC_SEVILLE = no;
      NET_DSA_AR9331 = no;
      NET_DSA_QCA8K = no;
      # NET_DSA_QCA8K_LEDS_SUPPORT is not set
      NET_DSA_SJA1105 = no;
      # NET_DSA_SJA1105_PTP is not set
      NET_DSA_XRS700X = no;
      NET_DSA_XRS700X_I2C = no;
      NET_DSA_XRS700X_MDIO = no;
      NET_DSA_REALTEK = no;
      # NET_DSA_REALTEK_MDIO is not set
      # NET_DSA_REALTEK_SMI is not set
      NET_DSA_KS8995 = no;
      NET_DSA_SMSC_LAN9303 = no;
      NET_DSA_SMSC_LAN9303_I2C = no;
      NET_DSA_SMSC_LAN9303_MDIO = no;
      NET_DSA_VITESSE_VSC73XX = no;
      NET_DSA_VITESSE_VSC73XX_SPI = no;
      NET_DSA_VITESSE_VSC73XX_PLATFORM = no;

      NET_VENDOR_3COM = no;
      PCMCIA_3C574 = no;
      PCMCIA_3C589 = no;
      VORTEX = no;
      TYPHOON = no;
      NET_VENDOR_ADAPTEC = no;
      ADAPTEC_STARFIRE = no;
      NET_VENDOR_AGERE = no;
      ET131X = no;
      NET_VENDOR_ALACRITECH = no;
      SLICOSS = no;
      NET_VENDOR_ALTEON = no;
      ACENIC = no;
      # ACENIC_OMIT_TIGON_I is not set
      ALTERA_TSE = no;
      NET_VENDOR_AMAZON = no;
      ENA_ETHERNET = no;
      NET_VENDOR_AMD = no;
      AMD8111_ETH = no;
      PCNET32 = no;
      PCMCIA_NMCLAN = no;
      AMD_XGBE = no;
      # AMD_XGBE_DCB is not set
      AMD_XGBE_HAVE_ECC = no;
      PDS_CORE = no;
      NET_VENDOR_AQUANTIA = no;
      AQTION = no;
      NET_VENDOR_ARC = no;
      NET_VENDOR_ASIX = no;
      SPI_AX88796C = no;
      # SPI_AX88796C_COMPRESSION is not set
      NET_VENDOR_ATHEROS = no;
      ATL2 = no;
      ATL1 = no;
      ATL1E = no;
      ATL1C = no;
      ALX = no;
      CX_ECAT = no;

      B44 = no;
      B44_PCI_AUTOSELECT = no;
      B44_PCICORE_AUTOSELECT = no;
      B44_PCI = no;
      BCMGENET = no;

      TIGON3 = no;
      TIGON3_HWMON = no;
      BNX2X = no;
      BNX2X_SRIOV = no;
      SYSTEMPORT = no;
      BNXT = no;
      BNXT_SRIOV = no;
      BNXT_FLOWER_OFFLOAD = no;
      # BNXT_DCB is not set
      BNXT_HWMON = no;
      BNGE = no;
      NET_VENDOR_CADENCE = no;
      MACB = no;
      MACB_USE_HWSTAMP = no;
      MACB_PCI = no;
      NET_VENDOR_CAVIUM = no;
      THUNDER_NIC_PF = no;
      THUNDER_NIC_VF = no;
      THUNDER_NIC_BGX = no;
      THUNDER_NIC_RGX = no;
      CAVIUM_PTP = no;
      LIQUIDIO_CORE = no;
      LIQUIDIO = no;
      LIQUIDIO_VF = no;

      CHELSIO_T1 = no;
      CHELSIO_T4VF = no;
      CHELSIO_INLINE_CRYPTO = no;
      CHELSIO_IPSEC_INLINE = no;
      CHELSIO_TLS_DEVICE = no;

      NET_VENDOR_CORTINA = no;
      GEMINI_ETHERNET = no;
      NET_VENDOR_DAVICOM = no;
      DM9051 = no;
      DNET = no;
      NET_VENDOR_DEC = no;
      NET_TULIP = no;
      DE2104X = no;
      TULIP = no;
      # TULIP_MWI is not set
      # TULIP_MMIO is not set
      # TULIP_NAPI is not set
      WINBOND_840 = no;
      DM9102 = no;
      ULI526X = no;
      PCMCIA_XIRCOM = no;
      NET_VENDOR_DLINK = no;
      DL2K = no;
      SUNDANCE = no;

      BE2NET_HWMON = no;
      BE2NET_BE2 = no;
      BE2NET_BE3 = no;
      BE2NET_LANCER = no;
      BE2NET_SKYHAWK = no;
      NET_VENDOR_ENGLEDER = no;
      TSNEP = no;
      # TSNEP_SELFTESTS is not set
      NET_VENDOR_EZCHIP = no;
      EZCHIP_NPS_MANAGEMENT_ENET = no;
      NET_VENDOR_FUJITSU = no;
      PCMCIA_FMVJ18X = no;
      NET_VENDOR_FUNGIBLE = no;
      FUN_CORE = no;
      FUN_ETH = no;
      NET_VENDOR_GOOGLE = no;
      GVE = no;
      NET_VENDOR_HISILICON = no;
      HIBMCGE = no;
      NET_VENDOR_HUAWEI = no;
      HINIC = no;
      HINIC3 = no;
      NET_VENDOR_I825XX = no;

      JME = no;
      NET_VENDOR_ADI = no;
      ADIN1110 = no;
      NET_VENDOR_LITEX = no;
      LITEX_LITEETH = no;
      NET_VENDOR_MARVELL = no;
      MVMDIO = no;
      SKGE = no;
      # SKGE_DEBUG is not set
      # SKGE_GENESIS is not set
      SKY2 = no;
      # SKY2_DEBUG is not set
      OCTEON_EP = no;
      OCTEON_EP_VF = no;
      PRESTERA = no;
      PRESTERA_PCI = no;

      MLX4_EN = no;
      MLX4_EN_DCB = no;

      MLX4_DEBUG = no;
      MLX4_CORE_GEN2 = no;
      MLX5_CORE = no;
      MLXSW_CORE = no;
      MLXSW_CORE_HWMON = no;
      MLXSW_CORE_THERMAL = no;
      MLXSW_PCI = no;
      MLXSW_I2C = no;
      MLXSW_SPECTRUM = no;
      MLXSW_SPECTRUM_DCB = no;
      MLXSW_MINIMAL = no;
      MLXFW = no;
      NET_VENDOR_META = no;
      FBNIC = no;
      NET_VENDOR_MICREL = no;
      KS8842 = no;
      KS8851 = no;
      KS8851_MLL = no;
      KSZ884X_PCI = no;
      NET_VENDOR_MICROCHIP = no;
      ENC28J60 = no;
      # ENC28J60_WRITEVERIFY is not set
      ENCX24J600 = no;
      LAN743X = no;
      LAN865X = no;
      LAN966X_SWITCH = no;
      LAN966X_DCB = no;
      VCAP = no;
      FDMA = no;
      NET_VENDOR_MICROSEMI = no;
      MSCC_OCELOT_SWITCH_LIB = no;
      MSCC_OCELOT_SWITCH = no;
      NET_VENDOR_MICROSOFT = no;
      MICROSOFT_MANA = no;
      NET_VENDOR_MYRI = no;
      MYRI10GE = no;
      MYRI10GE_DCA = no;
      FEALNX = no;
      NET_VENDOR_NI = no;
      NI_XGE_MANAGEMENT_ENET = no;
      NET_VENDOR_NATSEMI = no;
      NATSEMI = no;
      NS83820 = no;
      NET_VENDOR_NETERION = no;
      S2IO = no;
      NET_VENDOR_NETRONOME = no;
      NFP = no;
      NFP_APP_FLOWER = no;
      NFP_APP_ABM_NIC = no;
      NFP_NET_IPSEC = no;
      # NFP_DEBUG is not set
      NET_VENDOR_8390 = no;
      PCMCIA_AXNET = no;
      NE2K_PCI = no;
      PCMCIA_PCNET = no;
      NET_VENDOR_NVIDIA = no;
      FORCEDETH = no;
      NET_VENDOR_OKI = no;
      ETHOC = no;
      OA_TC6 = no;
      NET_VENDOR_PACKET_ENGINES = no;
      HAMACHI = no;
      YELLOWFIN = no;
      NET_VENDOR_PENSANDO = no;
      IONIC = no;
      NET_VENDOR_QLOGIC = no;
      QLA3XXX = no;
      QLCNIC = no;
      QLCNIC_SRIOV = no;
      QLCNIC_DCB = no;
      QLCNIC_HWMON = no;
      NETXEN_NIC = no;
      QED = no;
      QED_LL2 = no;
      QED_SRIOV = no;
      QEDE = no;
      QED_RDMA = no;
      QED_ISCSI = no;
      QED_FCOE = no;
      QED_OOO = no;
      NET_VENDOR_BROCADE = no;
      BNA = no;
      NET_VENDOR_QUALCOMM = no;
      QCA7000 = no;
      QCA7000_SPI = no;
      QCA7000_UART = no;
      QCOM_EMAC = no;
      RMNET = no;
      NET_VENDOR_RDC = no;
      R6040 = no;
      NET_VENDOR_REALTEK = no;
      ATP = no;
      "8139CP" = no;
      "8139TOO" = no;
      # 8139TOO_PIO is not set
      # 8139TOO_TUNE_TWISTER is not set
      # "8139TOO_8129" = no;
      # 8139_OLD_RX_RESET is not set
      R8169 = no;
      # R8169_LEDS is not set
      RTASE = no;
      NET_VENDOR_RENESAS = no;
      NET_VENDOR_ROCKER = no;
      ROCKER = no;
      NET_VENDOR_SAMSUNG = no;
      SXGBE_ETH = no;
      NET_VENDOR_SEEQ = no;
      NET_VENDOR_SILAN = no;
      SC92031 = no;
      NET_VENDOR_SIS = no;
      SIS900 = no;
      SIS190 = no;
      NET_VENDOR_SOLARFLARE = no;
      SFC = no;
      SFC_MTD = no;
      SFC_MCDI_MON = no;
      SFC_SRIOV = no;
      SFC_MCDI_LOGGING = no;
      SFC_FALCON = no;
      SFC_FALCON_MTD = no;
      SFC_SIENA = no;
      SFC_SIENA_MTD = no;
      SFC_SIENA_MCDI_MON = no;
      # SFC_SIENA_SRIOV is not set
      SFC_SIENA_MCDI_LOGGING = no;
      NET_VENDOR_SMSC = no;
      PCMCIA_SMC91C92 = no;
      EPIC100 = no;
      SMSC911X = no;
      SMSC9420 = no;
      NET_VENDOR_SOCIONEXT = no;
      NET_VENDOR_STMICRO = no;
      STMMAC_ETH = no;
      # STMMAC_SELFTESTS is not set
      STMMAC_PLATFORM = no;
      DWMAC_DWC_QOS_ETH = no;
      DWMAC_GENERIC = no;
      DWMAC_INTEL_PLAT = no;
      DWMAC_INTEL = no;
      STMMAC_PCI = no;
      NET_VENDOR_SUN = no;
      HAPPYMEAL = no;
      SUNGEM = no;
      CASSINI = no;
      NIU = no;
      NET_VENDOR_SYNOPSYS = no;
      DWC_XLGMAC = no;
      DWC_XLGMAC_PCI = no;
      NET_VENDOR_TEHUTI = no;
      TEHUTI = no;
      TEHUTI_TN40 = no;
      NET_VENDOR_TI = no;
      # TI_CPSW_PHY_SEL is not set
      TLAN = no;
      NET_VENDOR_VERTEXCOM = no;
      MSE102X = no;
      NET_VENDOR_VIA = no;
      VIA_RHINE = no;
      # VIA_RHINE_MMIO is not set
      VIA_VELOCITY = no;
      NET_VENDOR_WANGXUN = no;
      LIBWX = no;
      NGBE = no;
      TXGBE = no;
      TXGBEVF = no;
      NGBEVF = no;
      NET_VENDOR_WIZNET = no;
      WIZNET_W5100 = no;
      WIZNET_W5300 = no;
      # WIZNET_BUS_DIRECT is not set
      # WIZNET_BUS_INDIRECT is not set
      WIZNET_BUS_ANY = no;
      WIZNET_W5100_SPI = no;
      NET_VENDOR_XILINX = no;
      XILINX_EMACLITE = no;
      XILINX_AXI_EMAC = no;
      XILINX_LL_TEMAC = no;
      NET_VENDOR_XIRCOM = no;
      PCMCIA_XIRC2PS = no;
      FDDI = no;
      DEFXX = no;
      SKFP = no;
      HIPPI = mkForce no;
      ROADRUNNER = no;

      PHYLIB_LEDS = no;
      QCA807X_PHY = no;

      CAN_NETLINK = no;
      CAN_CALC_BITTIMING = no;
      CAN_RX_OFFLOAD = no;
      CAN_CAN327 = no;
      CAN_FLEXCAN = no;
      CAN_GRCAN = no;
      CAN_JANZ_ICAN3 = no;
      CAN_KVASER_PCIEFD = no;
      CAN_SLCAN = no;
      CAN_C_CAN = no;
      CAN_C_CAN_PLATFORM = no;
      CAN_C_CAN_PCI = no;
      CAN_CC770 = no;
      CAN_CC770_ISA = no;
      CAN_CC770_PLATFORM = no;
      CAN_CTUCANFD = no;
      CAN_CTUCANFD_PCI = no;
      CAN_CTUCANFD_PLATFORM = no;
      CAN_ESD_402_PCI = no;
      CAN_IFI_CANFD = no;
      CAN_M_CAN = no;
      CAN_M_CAN_PCI = no;
      CAN_M_CAN_PLATFORM = no;
      CAN_M_CAN_TCAN4X5X = no;
      CAN_PEAK_PCIEFD = no;
      CAN_SJA1000 = no;
      CAN_EMS_PCI = no;
      CAN_EMS_PCMCIA = no;
      CAN_F81601 = no;
      CAN_KVASER_PCI = no;
      CAN_PEAK_PCI = no;
      CAN_PEAK_PCIEC = no;
      CAN_PEAK_PCMCIA = no;
      CAN_PLX_PCI = no;
      CAN_SJA1000_ISA = no;
      CAN_SJA1000_PLATFORM = no;
      CAN_SOFTING = no;
      CAN_SOFTING_CS = no;

      #
      # CAN SPI interfaces
      #
      CAN_HI311X = no;
      CAN_MCP251X = no;
      CAN_MCP251XFD = no;
      # CAN_MCP251XFD_SANITY is not set
      # end of CAN SPI interfaces

      #
      # CAN USB interfaces
      #
      CAN_8DEV_USB = no;
      CAN_EMS_USB = no;
      CAN_ESD_USB = no;
      CAN_ETAS_ES58X = no;
      CAN_F81604 = no;
      CAN_GS_USB = no;
      CAN_KVASER_USB = no;
      CAN_MCBA_USB = no;
      CAN_NCT6694 = no;
      CAN_PEAK_USB = no;
      CAN_UCAN = no;
      # end of CAN USB interfaces

      MDIO_BITBANG = no;
      MDIO_BCM_UNIMAC = no;
      MDIO_CAVIUM = no;
      MDIO_GPIO = no;
      MDIO_HISI_FEMAC = no;
      MDIO_MVUSB = no;
      MDIO_MSCC_MIIM = no;
      MDIO_OCTEON = no;
      MDIO_IPQ4019 = no;
      MDIO_IPQ8064 = no;
      MDIO_REGMAP = no;
      MDIO_THUNDER = no;
      MDIO_BUS_MUX = no;
      MDIO_BUS_MUX_GPIO = no;
      MDIO_BUS_MUX_MULTIPLEXER = no;
      MDIO_BUS_MUX_MMIOREG = no;
      PCS_XPCS = no;
      PCS_LYNX = no;
      PCS_MTK_LYNXI = no;
      PLIP = no;

      ADM8211 = no;
      CARL9170 = no;
      AR5523 = no;
      WIL6210 = no;
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
      LIBERTAS = no;

      IPW2100 = no;
      IPW2200 = no;
      LIBIPW = no;
      IWLEGACY = no;
      IWL4965 = no;
      IWL3945 = no;

      P54_COMMON = no;
      MWIFIEX = no;
      MWIFIEX_SDIO = no;
      MWIFIEX_PCIE = no;
      MWIFIEX_USB = no;
      MWL8K = no;
      WILC1000 = no;
      WILC1000_SDIO = no;
      WILC1000_SPI = no;
      # WILC1000_HW_OOB_INTR is not set
      PLFXLC = no;
      RT2X00 = no;
      RT2400PCI = no;
      RT2500PCI = no;
      RT61PCI = no;
      RT2800PCI = no;
      RT2800PCI_RT33XX = no;
      RT2800PCI_RT35XX = no;
      RT2800PCI_RT53XX = no;
      RT2800PCI_RT3290 = no;
      RT2500USB = no;
      RT73USB = no;
      RT2800USB = no;
      RT2800USB_RT33XX = no;
      RT2800USB_RT35XX = no;
      # RT2800USB_RT3573 is not set
      RT2800USB_RT53XX = mkForce no;
      RT2800USB_RT55XX = mkForce no;
      # RT2800USB_UNKNOWN is not set
      RT2800_LIB = no;
      RT2800_LIB_MMIO = no;
      RT2X00_LIB_MMIO = no;
      RT2X00_LIB_PCI = no;
      RT2X00_LIB_USB = no;
      RT2X00_LIB = no;
      RT2X00_LIB_FIRMWARE = no;
      RT2X00_LIB_CRYPTO = no;
      RT2X00_LIB_LEDS = no;
      # RT2X00_LIB_DEBUGFS is not set
      # RT2X00_DEBUG is not set
      RTL8180 = no;
      RTL8187 = no;
      RTL8187_LEDS = no;
      RTL_CARDS = no;
      RTL8192CE = no;
      RTL8192SE = no;
      RTL8192DE = no;
      RTL8723AE = no;
      RTL8723BE = no;
      RTL8188EE = no;
      RTL8192EE = no;
      RTL8821AE = no;
      RTL8192CU = no;
      RTL8192DU = no;
      RTLWIFI = no;
      RTLWIFI_PCI = no;
      RTLWIFI_USB = no;
      RTLWIFI_DEBUG = no;
      RTL8192C_COMMON = no;
      RTL8192D_COMMON = no;
      RTL8723_COMMON = no;
      RTLBTCOEXIST = no;
      RTL8XXXU = no;
      RTL8XXXU_UNTESTED = mkForce no;
      RTW88 = mkForce no;
      RTW89 = mkForce no;
      WLAN_VENDOR_RSI = no;
      RSI_91X = no;
      RSI_DEBUGFS = no;
      RSI_SDIO = no;
      RSI_USB = no;
      RSI_COEX = no;
      WLAN_VENDOR_SILABS = no;
      WFX = no;
      WLAN_VENDOR_ST = no;
      CW1200 = no;
      CW1200_WLAN_SDIO = no;
      CW1200_WLAN_SPI = no;
      WLAN_VENDOR_TI = no;
      WL1251 = no;
      WL1251_SPI = no;
      WL1251_SDIO = no;
      WL12XX = no;
      WL18XX = no;
      WLCORE = no;
      WLCORE_SPI = no;
      WLCORE_SDIO = no;
      WLAN_VENDOR_ZYDAS = no;
      ZD1211RW = no;
      # ZD1211RW_DEBUG is not set
      WLAN_VENDOR_QUANTENNA = no;
      QTNFMAC = no;
      QTNFMAC_PCIE = no;
      MAC80211_HWSIM = no;
      VIRT_WIFI = no;
      WAN = mkForce no;
      HDLC = no;
      HDLC_RAW = no;
      HDLC_RAW_ETH = no;
      HDLC_CISCO = no;
      HDLC_FR = no;
      HDLC_PPP = no;
      HDLC_X25 = no;
      FRAMER = no;
      GENERIC_FRAMER = no;
      FRAMER_PEF2256 = no;
      PCI200SYN = no;
      WANXL = no;
      PC300TOO = no;
      FARSYNC = no;
      LAPBETHER = no;

      FUJITSU_ES = no;

      HYPERV_NET = no;

      KEYBOARD_ADC = no;
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
      KEYBOARD_CROS_EC = no;
      KEYBOARD_CAP11XX = no;
      KEYBOARD_BCM = no;
      KEYBOARD_MTK_PMIC = no;
      KEYBOARD_CYPRESS_SF = no;

      MOUSE_PS2 = no;
      MOUSE_PS2_ALPS = no;
      MOUSE_PS2_BYD = no;
      MOUSE_PS2_LOGIPS2PP = no;
      MOUSE_PS2_SYNAPTICS = no;
      MOUSE_PS2_SYNAPTICS_SMBUS = no;
      MOUSE_PS2_CYPRESS = no;
      MOUSE_PS2_LIFEBOOK = no;
      MOUSE_PS2_TRACKPOINT = no;
      MOUSE_PS2_ELANTECH = mkForce no;
      MOUSE_PS2_ELANTECH_SMBUS = mkForce no;
      # MOUSE_PS2_SENTELIC is not set
      # MOUSE_PS2_TOUCHKIT is not set
      MOUSE_PS2_FOCALTECH = no;
      MOUSE_PS2_VMMOUSE = mkForce no;
      MOUSE_PS2_SMBUS = no;

      MOUSE_APPLETOUCH = no;
      MOUSE_BCM5974 = no;
      MOUSE_CYAPA = no;
      MOUSE_ELAN_I2C = no;
      MOUSE_ELAN_I2C_I2C = no;
      MOUSE_ELAN_I2C_SMBUS = mkForce no;
      MOUSE_VSXXXAA = no;
      JOYSTICK_ADC = no;
      JOYSTICK_DB9 = no;
      JOYSTICK_GAMECON = no;
      JOYSTICK_TURBOGRAFX = no;
      JOYSTICK_WALKERA0701 = no;

      INPUT_TABLET = no;
      TABLET_USB_ACECAD = no;
      TABLET_USB_AIPTEK = no;
      TABLET_USB_HANWANG = no;
      TABLET_USB_KBTAB = no;
      TABLET_USB_PEGASUS = no;
      TABLET_SERIAL_WACOM4 = no;
      INPUT_TOUCHSCREEN = no;
      TOUCHSCREEN_ADS7846 = no;
      TOUCHSCREEN_AD7877 = no;
      TOUCHSCREEN_AD7879 = no;
      TOUCHSCREEN_AD7879_I2C = no;
      TOUCHSCREEN_AD7879_SPI = no;
      TOUCHSCREEN_ADC = no;
      TOUCHSCREEN_AR1021_I2C = no;
      TOUCHSCREEN_ATMEL_MXT = no;
      # TOUCHSCREEN_ATMEL_MXT_T37 is not set
      TOUCHSCREEN_AUO_PIXCIR = no;
      TOUCHSCREEN_BU21013 = no;
      TOUCHSCREEN_BU21029 = no;
      TOUCHSCREEN_CHIPONE_ICN8318 = no;
      TOUCHSCREEN_CHIPONE_ICN8505 = no;
      TOUCHSCREEN_CY8CTMA140 = no;
      TOUCHSCREEN_CY8CTMG110 = no;
      TOUCHSCREEN_CYTTSP_CORE = no;
      TOUCHSCREEN_CYTTSP_I2C = no;
      TOUCHSCREEN_CYTTSP_SPI = no;
      TOUCHSCREEN_CYTTSP5 = no;
      TOUCHSCREEN_DYNAPRO = no;
      TOUCHSCREEN_HAMPSHIRE = no;
      TOUCHSCREEN_EETI = no;
      TOUCHSCREEN_EGALAX = no;
      TOUCHSCREEN_EGALAX_SERIAL = no;
      TOUCHSCREEN_EXC3000 = no;
      TOUCHSCREEN_FUJITSU = no;
      TOUCHSCREEN_GOODIX = no;
      TOUCHSCREEN_GOODIX_BERLIN_CORE = no;
      TOUCHSCREEN_GOODIX_BERLIN_I2C = no;
      TOUCHSCREEN_GOODIX_BERLIN_SPI = no;
      TOUCHSCREEN_HIDEEP = no;
      TOUCHSCREEN_HIMAX_HX852X = no;
      TOUCHSCREEN_HYCON_HY46XX = no;
      TOUCHSCREEN_HYNITRON_CSTXXX = no;
      TOUCHSCREEN_HYNITRON_CST816X = no;
      TOUCHSCREEN_ILI210X = no;
      TOUCHSCREEN_ILITEK = no;
      TOUCHSCREEN_S6SY761 = no;
      TOUCHSCREEN_GUNZE = no;
      TOUCHSCREEN_EKTF2127 = no;
      TOUCHSCREEN_ELAN = no;
      TOUCHSCREEN_ELO = no;
      TOUCHSCREEN_WACOM_W8001 = no;
      TOUCHSCREEN_WACOM_I2C = no;
      TOUCHSCREEN_MAX11801 = no;
      TOUCHSCREEN_MMS114 = no;
      TOUCHSCREEN_MELFAS_MIP4 = no;
      TOUCHSCREEN_MSG2638 = no;
      TOUCHSCREEN_MTOUCH = no;
      TOUCHSCREEN_NOVATEK_NVT_TS = no;
      TOUCHSCREEN_IMAGIS = no;
      TOUCHSCREEN_IMX6UL_TSC = no;
      TOUCHSCREEN_INEXIO = no;
      TOUCHSCREEN_PENMOUNT = no;
      TOUCHSCREEN_EDT_FT5X06 = no;
      TOUCHSCREEN_TOUCHRIGHT = no;
      TOUCHSCREEN_TOUCHWIN = no;
      TOUCHSCREEN_PIXCIR = no;
      TOUCHSCREEN_WDT87XX_I2C = no;
      TOUCHSCREEN_WM97XX = no;
      TOUCHSCREEN_WM9705 = no;
      TOUCHSCREEN_WM9712 = no;
      TOUCHSCREEN_WM9713 = no;
      TOUCHSCREEN_USB_COMPOSITE = no;
      TOUCHSCREEN_MC13783 = no;
      TOUCHSCREEN_USB_EGALAX = no;
      TOUCHSCREEN_USB_PANJIT = no;
      TOUCHSCREEN_USB_3M = no;
      TOUCHSCREEN_USB_ITM = no;
      TOUCHSCREEN_USB_ETURBO = no;
      TOUCHSCREEN_USB_GUNZE = no;
      TOUCHSCREEN_USB_DMC_TSC10 = no;
      TOUCHSCREEN_USB_IRTOUCH = no;
      TOUCHSCREEN_USB_IDEALTEK = no;
      TOUCHSCREEN_USB_GENERAL_TOUCH = no;
      TOUCHSCREEN_USB_GOTOP = no;
      TOUCHSCREEN_USB_JASTEC = no;
      TOUCHSCREEN_USB_ELO = no;
      TOUCHSCREEN_USB_E2I = no;
      TOUCHSCREEN_USB_ZYTRONIC = no;
      TOUCHSCREEN_USB_ETT_TC45USB = no;
      TOUCHSCREEN_USB_NEXIO = no;
      TOUCHSCREEN_USB_EASYTOUCH = no;
      TOUCHSCREEN_TOUCHIT213 = no;
      TOUCHSCREEN_TSC_SERIO = no;
      TOUCHSCREEN_TSC200X_CORE = no;
      TOUCHSCREEN_TSC2004 = no;
      TOUCHSCREEN_TSC2005 = no;
      TOUCHSCREEN_TSC2007 = no;
      # TOUCHSCREEN_TSC2007_IIO is not set
      TOUCHSCREEN_RM_TS = no;
      TOUCHSCREEN_SILEAD = no;
      TOUCHSCREEN_SIS_I2C = no;
      TOUCHSCREEN_ST1232 = no;
      TOUCHSCREEN_STMFTS = no;
      TOUCHSCREEN_STMPE = no;
      TOUCHSCREEN_SUR40 = no;
      TOUCHSCREEN_SURFACE3_SPI = no;
      TOUCHSCREEN_SX8654 = no;
      TOUCHSCREEN_TPS6507X = no;
      TOUCHSCREEN_ZET6223 = no;
      TOUCHSCREEN_ZFORCE = no;
      TOUCHSCREEN_COLIBRI_VF50 = no;
      TOUCHSCREEN_ROHM_BU21023 = no;
      TOUCHSCREEN_IQS5XX = no;
      TOUCHSCREEN_IQS7211 = no;
      TOUCHSCREEN_ZINITIX = no;
      TOUCHSCREEN_HIMAX_HX83112B = no;
      INPUT_MISC = no;
      INPUT_88PM80X_ONKEY = no;
      INPUT_AD714X = no;
      INPUT_AD714X_I2C = no;
      INPUT_AD714X_SPI = no;
      INPUT_ARIZONA_HAPTICS = no;
      INPUT_ATC260X_ONKEY = no;
      INPUT_ATMEL_CAPTOUCH = no;
      INPUT_AW86927 = no;
      INPUT_BMA150 = no;
      INPUT_CS40L50_VIBRA = no;
      INPUT_E3X0_BUTTON = no;
      INPUT_PCSPKR = no;
      INPUT_MAX7360_ROTARY = no;
      INPUT_MAX77650_ONKEY = no;
      INPUT_MAX77693_HAPTIC = no;
      INPUT_MC13783_PWRBUTTON = no;
      INPUT_MMA8450 = no;
      INPUT_APANEL = no;
      INPUT_GPIO_BEEPER = no;
      INPUT_GPIO_DECODER = no;
      INPUT_GPIO_VIBRA = no;
      INPUT_CPCAP_PWRBUTTON = no;
      INPUT_ATLAS_BTNS = no;
      INPUT_ATI_REMOTE2 = no;
      INPUT_KEYSPAN_REMOTE = no;
      INPUT_KXTJ9 = no;
      INPUT_POWERMATE = no;
      INPUT_YEALINK = no;
      INPUT_CM109 = no;
      INPUT_REGULATOR_HAPTIC = no;
      INPUT_RETU_PWRBUTTON = no;
      INPUT_TPS65218_PWRBUTTON = no;
      INPUT_TPS65219_PWRBUTTON = no;
      INPUT_TPS6594_PWRBUTTON = no;
      INPUT_AXP20X_PEK = no;
      INPUT_UINPUT = no;
      INPUT_PALMAS_PWRBUTTON = no;
      INPUT_PCF8574 = no;
      INPUT_PWM_BEEPER = no;
      INPUT_PWM_VIBRA = no;
      INPUT_RK805_PWRKEY = no;
      INPUT_GPIO_ROTARY_ENCODER = no;
      INPUT_DA7280_HAPTICS = no;
      INPUT_DA9063_ONKEY = no;
      INPUT_ADXL34X = no;
      INPUT_ADXL34X_I2C = no;
      INPUT_ADXL34X_SPI = no;
      INPUT_IBM_PANEL = no;
      INPUT_IMS_PCU = no;
      INPUT_IQS269A = no;
      INPUT_IQS626A = no;
      INPUT_IQS7222 = no;
      INPUT_CMA3000 = no;
      INPUT_CMA3000_I2C = no;
      INPUT_XEN_KBDDEV_FRONTEND = no;
      INPUT_IDEAPAD_SLIDEBAR = no;
      INPUT_DRV260X_HAPTICS = no;
      INPUT_DRV2665_HAPTICS = no;
      INPUT_DRV2667_HAPTICS = no;
      INPUT_QNAP_MCU = no;
      INPUT_RAVE_SP_PWRBUTTON = no;
      INPUT_RT5120_PWRKEY = no;
      INPUT_STPMIC1_ONKEY = no;

      SERIO_I8042 = no;
      SERIO_CT82C710 = no;
      SERIO_PARKBD = no;
      SERIO_PCIPS2 = no;
      SERIO_LIBPS2 = no;
      SERIO_ALTERA_PS2 = no;
      SERIO_PS2MULT = no;
      SERIO_ARC_PS2 = no;
      SERIO_APBPS2 = no;
      SERIO_GPIO_PS2 = no;
      GAMEPORT_EMU10K1 = no;
      GAMEPORT_FM801 = no;

      SERIAL_8250_CS = no;
      SERIAL_8250_MEN_MCB = no;
      SERIAL_8250_DFL = no;

      SERIAL_SIFIVE = no;
      SERIAL_XILINX_PS_UART = no;
      SERIAL_CONEXANT_DIGICOLOR = no;
      SERIAL_MEN_Z135 = no;
      SERIAL_LITEUART = no;

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
      MWAVE = no;
      TELCLOCK = no;
      XILLYBUS_CLASS = no;
      XILLYBUS = no;
      XILLYBUS_PCIE = no;
      XILLYBUS_OF = no;
      XILLYUSB = no;

      HSI = no;
      HSI_BOARDINFO = no;

      ZL3073X = no;
      SSB = no;
      BCMA = no;

      RC_CORE = mkForce no;
      RC_DECODERS = mkForce no;
      RC_DEVICES = mkForce no;

      MEDIA_CEC_RC = mkForce no;
      VIDEO_TUNER = no;
      MEDIA_CONTROLLER_DVB = no;
      USB_S2255 = no;
      VIDEO_USBTV = no;
      USB_VIDEO_CLASS = no;
      USB_VIDEO_CLASS_INPUT_EVDEV = no;

      VIDEO_GO7007 = no;
      VIDEO_GO7007_USB = no;
      VIDEO_GO7007_LOADER = no;
      VIDEO_GO7007_USB_S2250_BOARD = no;
      VIDEO_HDPVR = no;
      VIDEO_PVRUSB2 = no;
      VIDEO_PVRUSB2_SYSFS = no;
      VIDEO_PVRUSB2_DVB = no;
      # VIDEO_PVRUSB2_DEBUGIFC is not set
      VIDEO_STK1160 = no;

      VIDEO_AU0828 = no;
      VIDEO_AU0828_V4L2 = no;
      # VIDEO_AU0828_RC is not set
      VIDEO_CX231XX = no;
      VIDEO_CX231XX_RC = no;
      VIDEO_CX231XX_ALSA = no;
      VIDEO_CX231XX_DVB = no;

      VIDEO_EM28XX = no;
      VIDEO_EM28XX_V4L2 = no;
      VIDEO_EM28XX_ALSA = no;
      VIDEO_EM28XX_DVB = no;
      VIDEO_EM28XX_RC = no;

      MEDIA_PCI_SUPPORT = mkForce no;

      #
      # Media capture support
      #
      VIDEO_MGB4 = no;
      VIDEO_SOLO6X10 = no;
      VIDEO_TW5864 = no;
      VIDEO_TW68 = no;
      VIDEO_TW686X = no;
      VIDEO_ZORAN = no;
      # VIDEO_ZORAN_DC30 is not set
      # VIDEO_ZORAN_ZR36060 is not set

      #
      # Media capture/analog TV support
      #
      VIDEO_DT3155 = no;
      VIDEO_IVTV = no;
      VIDEO_IVTV_ALSA = no;
      VIDEO_FB_IVTV = no;
      # VIDEO_FB_IVTV_FORCE_PAT is not set
      VIDEO_HEXIUM_GEMINI = no;
      VIDEO_HEXIUM_ORION = no;
      VIDEO_MXB = no;

      #
      # Media capture/analog/hybrid TV support
      #
      VIDEO_BT848 = no;
      DVB_BT8XX = no;
      VIDEO_CX18 = no;
      VIDEO_CX18_ALSA = no;
      VIDEO_CX23885 = no;
      MEDIA_ALTERA_CI = no;
      VIDEO_CX25821 = no;
      VIDEO_CX25821_ALSA = no;
      VIDEO_CX88 = no;
      VIDEO_CX88_ALSA = no;
      VIDEO_CX88_BLACKBIRD = no;
      VIDEO_CX88_DVB = no;
      VIDEO_CX88_ENABLE_VP3054 = no;
      VIDEO_CX88_VP3054 = no;
      VIDEO_CX88_MPEG = no;
      VIDEO_SAA7134 = no;
      VIDEO_SAA7134_ALSA = no;
      VIDEO_SAA7134_RC = no;
      VIDEO_SAA7134_DVB = no;
      VIDEO_SAA7134_GO7007 = no;
      VIDEO_SAA7164 = no;

      RADIO_ADAPTERS = no;
      USB_DSBR = no;
      USB_KEENE = no;
      USB_MA901 = no;
      USB_MR800 = no;
      USB_RAREMONO = no;
      USB_SI470X = no;
      I2C_SI470X = no;
      USB_SI4713 = no;
      PLATFORM_SI4713 = no;
      I2C_SI4713 = no;

      VIDEO_CADENCE_CSI2RX = no;
      VIDEO_CADENCE_CSI2TX = no;

      VIDEO_RP1_CFE = no;

      SMS_SDIO_DRV = no;

      MEDIA_COMMON_OPTIONS = no;

      CYPRESS_FIRMWARE = no;
      TTPCI_EEPROM = no;

      VIDEO_CX2341X = no;
      VIDEO_TVEEPROM = no;
      VIDEO_SAA7146 = no;
      VIDEO_SAA7146_VV = no;
      SMS_SIANO_MDTV = no;
      SMS_SIANO_RC = no;
      VIDEOBUF2_DMA_CONTIG = no;

      VIDEO_ADP1653 = no;
      VIDEO_LM3560 = no;
      VIDEO_LM3646 = no;

      VIDEO_CS3308 = no;
      VIDEO_CS5345 = no;
      VIDEO_CS53L32A = no;
      VIDEO_MSP3400 = no;
      VIDEO_SONY_BTF_MPX = no;
      VIDEO_TDA1997X = no;
      VIDEO_TDA7432 = no;
      VIDEO_TDA9840 = no;
      VIDEO_TEA6415C = no;
      VIDEO_TEA6420 = no;
      VIDEO_TLV320AIC23B = no;
      VIDEO_TVAUDIO = no;
      VIDEO_UDA1342 = no;
      VIDEO_VP27SMPX = no;
      VIDEO_WM8739 = no;
      VIDEO_WM8775 = no;

      VIDEO_SAA6588 = no;

      VIDEO_ADV7180 = no;
      VIDEO_ADV7183 = no;
      VIDEO_ADV748X = no;
      VIDEO_ADV7604 = no;
      # VIDEO_ADV7604_CEC is not set
      VIDEO_ADV7842 = no;
      # VIDEO_ADV7842_CEC is not set
      VIDEO_BT819 = no;
      VIDEO_BT856 = no;
      VIDEO_BT866 = no;
      VIDEO_ISL7998X = no;
      VIDEO_LT6911UXE = no;
      VIDEO_KS0127 = no;
      VIDEO_MAX9286 = no;
      VIDEO_ML86V7667 = no;
      VIDEO_SAA7110 = no;
      VIDEO_SAA711X = no;
      VIDEO_TC358743 = no;
      # VIDEO_TC358743_CEC is not set
      VIDEO_TC358746 = no;
      VIDEO_TVP514X = no;
      VIDEO_TVP5150 = no;
      VIDEO_TVP7002 = no;
      VIDEO_TW2804 = no;
      VIDEO_TW9900 = no;
      VIDEO_TW9903 = no;
      VIDEO_TW9906 = no;
      VIDEO_TW9910 = no;
      VIDEO_VPX3220 = no;

      VIDEO_SAA717X = no;
      VIDEO_CX25840 = no;

      VIDEO_ADV7170 = no;
      VIDEO_ADV7175 = no;
      VIDEO_ADV7343 = no;
      VIDEO_ADV7393 = no;
      VIDEO_AK881X = no;
      VIDEO_SAA7127 = no;
      VIDEO_SAA7185 = no;
      VIDEO_THS8200 = no;

      VIDEO_UPD64031A = no;
      VIDEO_UPD64083 = no;

      VIDEO_SAA6752HS = no;

      SDR_MAX2175 = no;

      VIDEO_I2C = no;
      VIDEO_M52790 = no;
      VIDEO_ST_MIPID02 = no;
      VIDEO_THS7303 = no;

      VIDEO_DS90UB913 = no;
      VIDEO_DS90UB953 = no;
      VIDEO_DS90UB960 = no;
      VIDEO_MAX96714 = no;
      VIDEO_MAX96717 = no;

      CXD2880_SPI_DRV = no;
      VIDEO_GS1662 = no;

      MEDIA_DIGITAL_TV_SUPPORT = mkForce no;
      MEDIA_ANALOG_TV_SUPPORT = mkForce no;
      MEDIA_RADIO_SUPPORT = no;
      MEDIA_SDR_SUPPORT = no;

      SND_FIREWIRE = no;
      SND_FIREWIRE_LIB = no;
      SND_DICE = no;
      SND_OXFW = no;
      SND_ISIGHT = no;
      SND_FIREWORKS = no;
      SND_BEBOB = no;
      SND_FIREWIRE_DIGI00X = no;
      SND_FIREWIRE_TASCAM = no;
      SND_FIREWIRE_MOTU = no;
      SND_FIREFACE = no;
      SND_PCMCIA = no;
      SND_VXPOCKET = no;
      SND_PDAUDIOCF = no;

      SND_SOC_MIKROE_PROTO = no;

      MEMSTICK = no;
      # MEMSTICK_DEBUG is not set

      #
      # MemoryStick drivers
      #
      # MEMSTICK_UNSAFE_RESUME is not set
      MSPRO_BLOCK = no;
      MS_BLOCK = no;

      #
      # MemoryStick Host Controller Drivers
      #
      MEMSTICK_TIFM_MS = no;
      MEMSTICK_JMICRON_38X = no;
      MEMSTICK_R592 = no;
      MEMSTICK_REALTEK_USB = no;

      ACCESSIBILITY = mkForce no; # Set in nixpkgs
      SPEAKUP = no;

      GREYBUS = no;
      COMEDI = no;
      STAGING = mkForce no;
      RTL8723BS = no;

      #
      # IIO staging drivers
      #

      ADIS16203 = no;
      AD7816 = no;
      ADT7316 = no;
      ADT7316_SPI = no;
      ADT7316_I2C = no;
      AD9832 = no;
      AD9834 = no;
      AD5933 = no;
      # end of IIO staging drivers

      FB_SM750 = no;
      STAGING_MEDIA = mkForce no;
      VIDEO_MAX96712 = no;

      #
      # StarFive media platform drivers
      #
      FB_TFT = no;
      FB_TFT_AGM1264K_FL = no;
      FB_TFT_BD663474 = no;
      FB_TFT_HX8340BN = no;
      FB_TFT_HX8347D = no;
      FB_TFT_HX8353D = no;
      FB_TFT_HX8357D = no;
      FB_TFT_ILI9163 = no;
      FB_TFT_ILI9320 = no;
      FB_TFT_ILI9325 = no;
      FB_TFT_ILI9340 = no;
      FB_TFT_ILI9341 = no;
      FB_TFT_ILI9481 = no;
      FB_TFT_ILI9486 = no;
      FB_TFT_PCD8544 = no;
      FB_TFT_RA8875 = no;
      FB_TFT_S6D02A1 = no;
      FB_TFT_S6D1121 = no;
      FB_TFT_SEPS525 = no;
      FB_TFT_SH1106 = no;
      FB_TFT_SSD1289 = no;
      FB_TFT_SSD1305 = no;
      FB_TFT_SSD1306 = no;
      FB_TFT_SSD1331 = no;
      FB_TFT_SSD1351 = no;
      FB_TFT_ST7735R = no;
      FB_TFT_ST7789V = no;
      FB_TFT_TINYLCD = no;
      FB_TFT_TLS8204 = no;
      FB_TFT_UC1611 = no;
      FB_TFT_UC1701 = no;
      FB_TFT_UPD161704 = no;
      MOST_COMPONENTS = no;
      MOST_NET = no;
      MOST_VIDEO = no;
      MOST_DIM2 = no;

      XIL_AXIS_FIFO = no;
      # VME_BUS is not set
      GPIB = no;
      GPIB_COMMON = no;
      GPIB_AGILENT_82350B = no;
      GPIB_AGILENT_82357A = no;
      GPIB_CEC_PCI = no;
      GPIB_NI_PCI_ISA = no;
      GPIB_CB7210 = no;
      GPIB_NI_USB = no;
      GPIB_FLUKE = no;
      GPIB_FMH = no;
      GPIB_INES = no;
      GPIB_PCMCIA = no;
      GPIB_LPVO = no;
      GPIB_TMS9914 = no;
      GPIB_NEC7210 = no;

      CHROME_PLATFORMS = mkForce no;

      WILCO_EC = no;
      WILCO_EC_DEBUGFS = no;
      WILCO_EC_EVENTS = no;
      WILCO_EC_TELEMETRY = no;

      IDEAPAD_LAPTOP = no;
      LENOVO_YMC = no;
      MSI_LAPTOP = no;
      SAMSUNG_GALAXYBOOK = no;
      SAMSUNG_LAPTOP = no;
      SAMSUNG_Q10 = no;
      ACPI_TOSHIBA = no;

      LITEX = no;
      LITEX_SOC_CONTROLLER = no;
      # end of Enable LiteX SoC Builder specific drivers

      WPCM450_SOC = no;
      # WPCM450_SOC is not set

      #
      # Qualcomm SoC drivers
      #
      QCOM_PDR_HELPERS = no;
      QCOM_PDR_MSG = no;
      QCOM_PMIC_PDCHARGER_ULOG = no;
      QCOM_PMIC_GLINK = no;
      QCOM_QMI_HELPERS = no;
      QCOM_PBS = no;

      IIO = no;
      IIO_BUFFER = no;
      IIO_BUFFER_CB = no;
      IIO_BUFFER_DMA = no;
      IIO_BUFFER_DMAENGINE = no;
      IIO_BUFFER_HW_CONSUMER = no;
      IIO_KFIFO_BUF = no;
      IIO_TRIGGERED_BUFFER = no;
      IIO_CONFIGFS = no;
      IIO_GTS_HELPER = no;
      IIO_TRIGGER = no;
      IIO_SW_DEVICE = no;
      IIO_SW_TRIGGER = no;
      IIO_TRIGGERED_EVENT = no;
      IIO_BACKEND = no;

      #
      # Accelerometers
      #
      ADIS16201 = no;
      ADIS16209 = no;
      ADXL313 = no;
      ADXL313_I2C = no;
      ADXL313_SPI = no;
      ADXL355 = no;
      ADXL355_I2C = no;
      ADXL355_SPI = no;
      ADXL367 = no;
      ADXL367_SPI = no;
      ADXL367_I2C = no;
      ADXL372 = no;
      ADXL372_SPI = no;
      ADXL372_I2C = no;
      ADXL380 = no;
      ADXL380_SPI = no;
      ADXL380_I2C = no;
      BMA220 = no;
      BMA400 = no;
      BMA400_I2C = no;
      BMA400_SPI = no;
      BMC150_ACCEL = no;
      BMC150_ACCEL_I2C = no;
      BMC150_ACCEL_SPI = no;
      BMI088_ACCEL = no;
      BMI088_ACCEL_I2C = no;
      BMI088_ACCEL_SPI = no;
      DA280 = no;
      DA311 = no;
      DMARD06 = no;
      DMARD09 = no;
      DMARD10 = no;
      FXLS8962AF = no;
      FXLS8962AF_I2C = no;
      FXLS8962AF_SPI = no;
      HID_SENSOR_ACCEL_3D = no;
      IIO_CROS_EC_ACCEL_LEGACY = no;
      IIO_ST_ACCEL_3AXIS = no;
      IIO_ST_ACCEL_I2C_3AXIS = no;
      IIO_ST_ACCEL_SPI_3AXIS = no;
      IIO_KX022A = no;
      IIO_KX022A_SPI = no;
      IIO_KX022A_I2C = no;
      KXSD9 = no;
      KXSD9_SPI = no;
      KXSD9_I2C = no;
      KXCJK1013 = no;
      MC3230 = no;
      MMA7455 = no;
      MMA7455_I2C = no;
      MMA7455_SPI = no;
      MMA7660 = no;
      MMA8452 = no;
      MMA9551_CORE = no;
      MMA9551 = no;
      MMA9553 = no;
      MSA311 = no;
      MXC4005 = no;
      MXC6255 = no;
      SCA3000 = no;
      SCA3300 = no;
      STK8312 = no;
      STK8BA50 = no;
      # end of Accelerometers

      #
      # Analog to digital converters
      #
      IIO_ADC_HELPER = no;
      AD_SIGMA_DELTA = no;
      AD4000 = no;
      AD4030 = no;
      AD4080 = no;
      AD4130 = no;
      AD4170_4 = no;
      AD4695 = no;
      AD4851 = no;
      AD7091R = no;
      AD7091R5 = no;
      AD7091R8 = no;
      AD7124 = no;
      AD7173 = no;
      AD7191 = no;
      AD7192 = no;
      AD7266 = no;
      AD7280 = no;
      AD7291 = no;
      AD7292 = no;
      AD7298 = no;
      AD7380 = no;
      AD7405 = no;
      AD7476 = no;
      AD7606 = no;
      AD7606_IFACE_PARALLEL = no;
      AD7606_IFACE_SPI = no;
      AD7625 = no;
      AD7766 = no;
      AD7768_1 = no;
      AD7779 = no;
      AD7780 = no;
      AD7791 = no;
      AD7793 = no;
      AD7887 = no;
      AD7923 = no;
      AD7944 = no;
      AD7949 = no;
      AD799X = no;
      AD9467 = no;
      ADE9000 = no;
      AXP20X_ADC = no;
      AXP288_ADC = no;
      CC10001_ADC = no;
      CPCAP_ADC = no;
      DA9150_GPADC = no;
      DLN2_ADC = no;
      ENVELOPE_DETECTOR = no;
      GEHC_PMC_ADC = no;
      HI8435 = no;
      HX711 = no;
      INA2XX_ADC = no;
      INTEL_DC_TI_ADC = no;
      INTEL_MRFLD_ADC = no;
      LTC2309 = no;
      LTC2471 = no;
      LTC2485 = no;
      LTC2496 = no;
      LTC2497 = no;
      MAX1027 = no;
      MAX11100 = no;
      MAX1118 = no;
      MAX11205 = no;
      MAX11410 = no;
      MAX1241 = no;
      MAX1363 = no;
      MAX34408 = no;
      MAX77541_ADC = no;
      MAX9611 = no;
      MCP320X = no;
      MCP3422 = no;
      MCP3564 = no;
      MCP3911 = no;
      MEDIATEK_MT6359_AUXADC = no;
      MEDIATEK_MT6360_ADC = no;
      MEDIATEK_MT6370_ADC = no;
      MEN_Z188_ADC = no;
      MP2629_ADC = no;
      NAU7802 = no;
      NCT7201 = no;
      PAC1921 = no;
      PAC1934 = no;
      PALMAS_GPADC = no;
      QCOM_VADC_COMMON = no;
      QCOM_SPMI_IADC = no;
      QCOM_SPMI_VADC = no;
      QCOM_SPMI_ADC5 = no;
      RN5T618_ADC = no;
      ROHM_BD79112 = no;
      ROHM_BD79124 = no;
      RICHTEK_RTQ6056 = no;
      SD_ADC_MODULATOR = no;
      STMPE_ADC = no;
      TI_ADC081C = no;
      TI_ADC0832 = no;
      TI_ADC084S021 = no;
      TI_ADC108S102 = no;
      TI_ADC12138 = no;
      TI_ADC128S052 = no;
      TI_ADC161S626 = no;
      TI_ADS1015 = no;
      TI_ADS1100 = no;
      TI_ADS1119 = no;
      TI_ADS124S08 = no;
      TI_ADS1298 = no;
      TI_ADS131E08 = no;
      TI_ADS7138 = no;
      TI_ADS7924 = no;
      TI_ADS7950 = no;
      TI_ADS8344 = no;
      TI_ADS8688 = no;
      TI_LMP92064 = no;
      TI_TLC4541 = no;
      TI_TSC2046 = no;
      VF610_ADC = no;
      VIPERBOARD_ADC = no;
      XILINX_XADC = no;
      # end of Analog to digital converters

      #
      # Analog to digital and digital to analog converters
      #
      AD74115 = no;
      AD74413R = no;
      # end of Analog to digital and digital to analog converters

      #
      # Analog Front Ends
      #
      IIO_RESCALE = no;
      # end of Analog Front Ends

      #
      # Amplifiers
      #
      AD8366 = no;
      ADA4250 = no;
      HMC425 = no;
      # end of Amplifiers

      #
      # Capacitance to digital converters
      #
      AD7150 = no;
      AD7746 = no;
      # end of Capacitance to digital converters

      #
      # Chemical Sensors
      #
      AOSONG_AGS02MA = no;
      ATLAS_PH_SENSOR = no;
      ATLAS_EZO_SENSOR = no;
      BME680 = no;
      BME680_I2C = no;
      BME680_SPI = no;
      CCS811 = no;
      ENS160 = no;
      ENS160_I2C = no;
      ENS160_SPI = no;
      IAQCORE = no;
      MHZ19B = no;
      PMS7003 = no;
      SCD30_CORE = no;
      SCD30_I2C = no;
      SCD30_SERIAL = no;
      SCD4X = no;
      SEN0322 = no;
      SENSIRION_SGP30 = no;
      SENSIRION_SGP40 = no;
      SPS30 = no;
      SPS30_I2C = no;
      SPS30_SERIAL = no;
      SENSEAIR_SUNRISE_CO2 = no;
      VZ89X = no;
      # end of Chemical Sensors

      IIO_CROS_EC_SENSORS_CORE = no;
      IIO_CROS_EC_SENSORS = no;
      IIO_CROS_EC_SENSORS_LID_ANGLE = no;
      IIO_CROS_EC_ACTIVITY = no;

      #
      # Hid Sensor IIO Common
      #
      HID_SENSOR_IIO_COMMON = no;
      HID_SENSOR_IIO_TRIGGER = no;
      # end of Hid Sensor IIO Common

      IIO_INV_SENSORS_TIMESTAMP = no;
      IIO_MS_SENSORS_I2C = no;

      #
      # IIO SCMI Sensors
      #
      # end of IIO SCMI Sensors

      #
      # SSP Sensor Common
      #
      IIO_SSP_SENSORS_COMMONS = no;
      IIO_SSP_SENSORHUB = no;
      # end of SSP Sensor Common

      IIO_ST_SENSORS_I2C = no;
      IIO_ST_SENSORS_SPI = no;
      IIO_ST_SENSORS_CORE = no;

      #
      # Digital to analog converters
      #
      AD3530R = no;
      AD3552R_HS = no;
      AD3552R_LIB = no;
      AD3552R = no;
      AD5064 = no;
      AD5360 = no;
      AD5380 = no;
      AD5421 = no;
      AD5446 = no;
      AD5449 = no;
      AD5592R_BASE = no;
      AD5592R = no;
      AD5593R = no;
      AD5504 = no;
      AD5624R_SPI = no;
      AD9739A = no;
      LTC2688 = no;
      AD5686 = no;
      AD5686_SPI = no;
      AD5696_I2C = no;
      AD5755 = no;
      AD5758 = no;
      AD5761 = no;
      AD5764 = no;
      AD5766 = no;
      AD5770R = no;
      AD5791 = no;
      AD7293 = no;
      AD7303 = no;
      AD8460 = no;
      AD8801 = no;
      BD79703 = no;
      DPOT_DAC = no;
      DS4424 = no;
      LTC1660 = no;
      LTC2632 = no;
      LTC2664 = no;
      M62332 = no;
      MAX517 = no;
      MAX5522 = no;
      MAX5821 = no;
      MCP4725 = no;
      MCP4728 = no;
      MCP4821 = no;
      MCP4922 = no;
      TI_DAC082S085 = no;
      TI_DAC5571 = no;
      TI_DAC7311 = no;
      TI_DAC7612 = no;
      VF610_DAC = no;
      # end of Digital to analog converters

      #
      # IIO dummy driver
      #
      IIO_SIMPLE_DUMMY = no;
      # IIO_SIMPLE_DUMMY_EVENTS is not set
      # IIO_SIMPLE_DUMMY_BUFFER is not set
      # end of IIO dummy driver

      #
      # Filters
      #
      ADMV8818 = no;
      # end of Filters

      #
      # Frequency Synthesizers DDS/PLL
      #

      #
      # Clock Generator/Distribution
      #
      AD9523 = no;
      # end of Clock Generator/Distribution

      #
      # Phase-Locked Loop (PLL) frequency synthesizers
      #
      ADF4350 = no;
      ADF4371 = no;
      ADF4377 = no;
      ADMFM2000 = no;
      ADMV1013 = no;
      ADMV1014 = no;
      ADMV4420 = no;
      ADRF6780 = no;
      # end of Phase-Locked Loop (PLL) frequency synthesizers
      # end of Frequency Synthesizers DDS/PLL

      #
      # Digital gyroscope sensors
      #
      ADIS16080 = no;
      ADIS16130 = no;
      ADIS16136 = no;
      ADIS16260 = no;
      ADXRS290 = no;
      ADXRS450 = no;
      BMG160 = no;
      BMG160_I2C = no;
      BMG160_SPI = no;
      FXAS21002C = no;
      FXAS21002C_I2C = no;
      FXAS21002C_SPI = no;
      HID_SENSOR_GYRO_3D = no;
      MPU3050 = no;
      MPU3050_I2C = no;
      IIO_ST_GYRO_3AXIS = no;
      IIO_ST_GYRO_I2C_3AXIS = no;
      IIO_ST_GYRO_SPI_3AXIS = no;
      ITG3200 = no;
      # end of Digital gyroscope sensors

      #
      # Health Sensors
      #

      #
      # Heart Rate Monitors
      #
      AFE4403 = no;
      AFE4404 = no;
      MAX30100 = no;
      MAX30102 = no;
      # end of Heart Rate Monitors
      # end of Health Sensors

      #
      # Humidity sensors
      #
      AM2315 = no;
      DHT11 = no;
      ENS210 = no;
      HDC100X = no;
      HDC2010 = no;
      HDC3020 = no;
      HID_SENSOR_HUMIDITY = no;
      HTS221 = no;
      HTS221_I2C = no;
      HTS221_SPI = no;
      HTU21 = no;
      SI7005 = no;
      SI7020 = no;
      # end of Humidity sensors

      #
      # Inertial measurement units
      #
      ADIS16400 = no;
      ADIS16460 = no;
      ADIS16475 = no;
      ADIS16480 = no;
      ADIS16550 = no;
      BMI160 = no;
      BMI160_I2C = no;
      BMI160_SPI = no;
      BMI270 = no;
      BMI270_I2C = no;
      BMI270_SPI = no;
      BMI323 = no;
      BMI323_I2C = no;
      BMI323_SPI = no;
      BOSCH_BNO055 = no;
      BOSCH_BNO055_SERIAL = no;
      BOSCH_BNO055_I2C = no;
      FXOS8700 = no;
      FXOS8700_I2C = no;
      FXOS8700_SPI = no;
      KMX61 = no;
      INV_ICM42600 = no;
      INV_ICM42600_I2C = no;
      INV_ICM42600_SPI = no;
      INV_MPU6050_IIO = no;
      INV_MPU6050_I2C = no;
      INV_MPU6050_SPI = no;
      SMI240 = no;
      IIO_ST_LSM6DSX = no;
      IIO_ST_LSM6DSX_I2C = no;
      IIO_ST_LSM6DSX_SPI = no;
      IIO_ST_LSM6DSX_I3C = no;
      IIO_ST_LSM9DS0 = no;
      IIO_ST_LSM9DS0_I2C = no;
      IIO_ST_LSM9DS0_SPI = no;
      # end of Inertial measurement units

      IIO_ADIS_LIB = no;
      IIO_ADIS_LIB_BUFFER = no;

      #
      # Light sensors
      #
      ACPI_ALS = no;
      ADJD_S311 = no;
      ADUX1020 = no;
      AL3000A = no;
      AL3010 = no;
      AL3320A = no;
      APDS9160 = no;
      APDS9300 = no;
      APDS9306 = no;
      AS73211 = no;
      BH1745 = no;
      BH1750 = no;
      BH1780 = no;
      CM32181 = no;
      CM3232 = no;
      CM3323 = no;
      CM3605 = no;
      CM36651 = no;
      IIO_CROS_EC_LIGHT_PROX = no;
      GP2AP002 = no;
      GP2AP020A00F = no;
      IQS621_ALS = no;
      SENSORS_ISL29018 = no;
      SENSORS_ISL29028 = no;
      ISL29125 = no;
      ISL76682 = no;
      HID_SENSOR_ALS = no;
      HID_SENSOR_PROX = no;
      JSA1212 = no;
      ROHM_BU27034 = no;
      RPR0521 = no;
      SENSORS_LM3533 = no;
      LTR390 = no;
      LTR501 = no;
      LTRF216A = no;
      LV0104CS = no;
      MAX44000 = no;
      MAX44009 = no;
      NOA1305 = no;
      OPT3001 = no;
      OPT4001 = no;
      OPT4060 = no;
      PA12203001 = no;
      SI1133 = no;
      SI1145 = no;
      STK3310 = no;
      ST_UVIS25 = no;
      ST_UVIS25_I2C = no;
      ST_UVIS25_SPI = no;
      TCS3414 = no;
      TCS3472 = no;
      SENSORS_TSL2563 = no;
      TSL2583 = no;
      TSL2591 = no;
      TSL2772 = no;
      TSL4531 = no;
      US5182D = no;
      VCNL4000 = no;
      VCNL4035 = no;
      VEML3235 = no;
      VEML6030 = no;
      VEML6040 = no;
      VEML6046X00 = no;
      VEML6070 = no;
      VEML6075 = no;
      VL6180 = no;
      ZOPT2201 = no;
      # end of Light sensors

      #
      # Magnetometer sensors
      #
      AF8133J = no;
      AK8974 = no;
      AK8975 = no;
      AK09911 = no;
      ALS31300 = no;
      BMC150_MAGN = no;
      BMC150_MAGN_I2C = no;
      BMC150_MAGN_SPI = no;
      MAG3110 = no;
      HID_SENSOR_MAGNETOMETER_3D = no;
      MMC35240 = no;
      IIO_ST_MAGN_3AXIS = no;
      IIO_ST_MAGN_I2C_3AXIS = no;
      IIO_ST_MAGN_SPI_3AXIS = no;
      INFINEON_TLV493D = no;
      SENSORS_HMC5843 = no;
      SENSORS_HMC5843_I2C = no;
      SENSORS_HMC5843_SPI = no;
      SENSORS_RM3100 = no;
      SENSORS_RM3100_I2C = no;
      SENSORS_RM3100_SPI = no;
      SI7210 = no;
      TI_TMAG5273 = no;
      YAMAHA_YAS530 = no;
      # end of Magnetometer sensors

      #
      # Multiplexers
      #
      IIO_MUX = no;
      # end of Multiplexers

      #
      # Inclinometer sensors
      #
      HID_SENSOR_INCLINOMETER_3D = no;
      HID_SENSOR_DEVICE_ROTATION = no;
      # end of Inclinometer sensors

      #
      # Triggers - standalone
      #
      IIO_HRTIMER_TRIGGER = no;
      IIO_INTERRUPT_TRIGGER = no;
      IIO_TIGHTLOOP_TRIGGER = no;
      IIO_SYSFS_TRIGGER = no;
      # end of Triggers - standalone

      #
      # Linear and angular position sensors
      #
      IQS624_POS = no;
      HID_SENSOR_CUSTOM_INTEL_HINGE = no;
      # end of Linear and angular position sensors

      #
      # Digital potentiometers
      #
      AD5110 = no;
      AD5272 = no;
      DS1803 = no;
      MAX5432 = no;
      MAX5481 = no;
      MAX5487 = no;
      MCP4018 = no;
      MCP4131 = no;
      MCP4531 = no;
      MCP41010 = no;
      TPL0102 = no;
      X9250 = no;
      # end of Digital potentiometers

      #
      # Digital potentiostats
      #
      LMP91000 = no;
      # end of Digital potentiostats

      #
      # Pressure sensors
      #
      ABP060MG = no;
      ROHM_BM1390 = no;
      BMP280 = no;
      BMP280_I2C = no;
      BMP280_SPI = no;
      IIO_CROS_EC_BARO = no;
      DLHL60D = no;
      DPS310 = no;
      HID_SENSOR_PRESS = no;
      HP03 = no;
      HSC030PA = no;
      HSC030PA_I2C = no;
      HSC030PA_SPI = no;
      ICP10100 = no;
      MPL115 = no;
      MPL115_I2C = no;
      MPL115_SPI = no;
      MPL3115 = no;
      MPRLS0025PA = no;
      MPRLS0025PA_I2C = no;
      MPRLS0025PA_SPI = no;
      MS5611 = no;
      MS5611_I2C = no;
      MS5611_SPI = no;
      MS5637 = no;
      SDP500 = no;
      IIO_ST_PRESS = no;
      IIO_ST_PRESS_I2C = no;
      IIO_ST_PRESS_SPI = no;
      T5403 = no;
      HP206C = no;
      ZPA2326 = no;
      ZPA2326_I2C = no;
      ZPA2326_SPI = no;
      # end of Pressure sensors

      #
      # Lightning sensors
      #
      AS3935 = no;
      # end of Lightning sensors

      #
      # Proximity and distance sensors
      #
      CROS_EC_MKBP_PROXIMITY = no;
      D3323AA = no;
      HX9023S = no;
      IRSD200 = no;
      ISL29501 = no;
      LIDAR_LITE_V2 = no;
      MB1232 = no;
      PING = no;
      RFD77402 = no;
      SRF04 = no;
      SX_COMMON = no;
      SX9310 = no;
      SX9324 = no;
      SX9360 = no;
      SX9500 = no;
      SRF08 = no;
      VCNL3020 = no;
      VL53L0X_I2C = no;
      AW96103 = no;
      # end of Proximity and distance sensors

      #
      # Resolver to digital converters
      #
      AD2S90 = no;
      AD2S1200 = no;
      AD2S1210 = no;
      # end of Resolver to digital converters

      #
      # Temperature sensors
      #
      IQS620AT_TEMP = no;
      LTC2983 = no;
      MAXIM_THERMOCOUPLE = no;
      HID_SENSOR_TEMP = no;
      MLX90614 = no;
      MLX90632 = no;
      MLX90635 = no;
      TMP006 = no;
      TMP007 = no;
      TMP117 = no;
      TSYS01 = no;
      TSYS02D = no;
      MAX30208 = no;
      MAX31856 = no;
      MAX31865 = no;
      MCP9600 = no;
      # end of Temperature sensors

      NTB = no;
      # NTB_MSI is not set
      NTB_AMD = no;
      NTB_IDT = no;
      NTB_INTEL = no;
      NTB_EPF = no;
      NTB_SWITCHTEC = no;
      NTB_PINGPONG = no;
      NTB_TOOL = no;
      NTB_PERF = no;
      NTB_TRANSPORT = no;

      FPGA = no;
      FSI = no;

      # FSI_NEW_DEV_NODE is not set
      FSI_MASTER_GPIO = no;
      FSI_MASTER_HUB = no;
      FSI_MASTER_ASPEED = no;
      FSI_MASTER_I2CR = no;
      FSI_SCOM = no;
      FSI_SBEFIFO = no;
      FSI_OCC = no;
      I2CR_SCOM = no;

      MOST = no;
      MOST_USB_HDM = no;
      MOST_CDEV = no;
      MOST_SND = no;
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
