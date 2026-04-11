{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Explicit KConfig to use during build to do some extra configuration
  boot.kernelPatches = [
    {
      name = "97-skip-amd-support";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
        CONFIG_CPU_SUP_AMD = no;
        CONFIG_AGP_AMD = no;
        CONFIG_AGP_AMD64 = no;
        COFNIG_X86_AMD_PSTATE = no;
        CONFIG_AMD_IOMMU_V2 = no;
        CONFIG_DRM_AMDGPU = no;
      };
    }

    {
      name = "98-dont-build-unused-drivers";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
        CONFIG_GOOGLE_FIRMWARE = no;
        CONFIG_GOOGLE_SMI = no;
        CONFIG_GOOGLE_CBMEM = no;
        CONFIG_GOOGLE_COREBOOT_TABLE = no;
        CONFIG_GOOGLE_MEMCONSOLE = no;
        CONFIG_GOOGLE_MEMCONSOLE_X86_LEGACY = no;
        CONFIG_GOOGLE_FRAMEBUFFER_COREBOOT = no;
        CONFIG_GOOGLE_MEMCONSOLE_COREBOOT = no;
        CONFIG_GOOGLE_VPD = no;

        # General modules I don't use
        CONFIG_HAMRADIO = no;
        CONFIG_PCCARD = no;
        CONFIG_PCMCIA = no;
        CONFIG_PCMCIA_LOAD_CIS = no;
        CONFIG_CARDBUS = no;

        CONFIG_YENTA = no;
        CONFIG_YENTA_O2 = no;
        CONFIG_YENTA_RICOH = no;
        CONFIG_YENTA_TI = no;
        CONFIG_YENTA_ENE_TUNE = no;
        CONFIG_YENTA_TOSHIBA = no;
        CONFIG_PD6729 = no;
        CONFIG_I82092 = no;
        CONFIG_PCCARD_NONSTATIC = no;

        CONFIG_MOXTET = no;

        CONFIG_PCIE_CADENCE_PLAT_HOST = no;
        CONFIG_PCIE_PLDA_HOST = no;
        CONFIG_PCIE_MICROCHIP_HOST = no;

        CONFIG_SENSORS_LIS3LV02D = no;
        CONFIG_AD525X_DPOT = no;
        CONFIG_AD525X_DPOT_I2C = no;
        CONFIG_AD525X_DPOT_SPI = no;

        CONFIG_DUMMY_IRQ = no;
        CONFIG_IBM_ASM = no;
        CONFIG_PHANTOM = no;
        CONFIG_ICS932S401 = no;
        CONFIG_SMPRO_ERRMON = no;
        CONFIG_SMPRO_MISC = no;
        CONFIG_HI6421V600_IRQ = no;
        CONFIG_HP_ILO = no;
        CONFIG_APDS9802ALS = no;
        CONFIG_ISL29003 = no;
        CONFIG_ISL29020 = no;
        CONFIG_SENSORS_TSL2550 = no;
        CONFIG_SENSORS_BH1770 = no;
        CONFIG_SENSORS_APDS990X = no;
        CONFIG_HMC6352 = no;
        CONFIG_DS1682 = no;
        CONFIG_VMWARE_BALLOON = no;
        CONFIG_LATTICE_ECP3_CONFIG = no;
        CONFIG_DW_XDATA_PCIE = no;
        CONFIG_PCI_ENDPOINT_TEST = no;
        CONFIG_XILINX_SDFEC = no;
        CONFIG_HISI_HIKEY_USB = no;
        CONFIG_OPEN_DICE = no;
        CONFIG_VCPU_STALL_DETECTOR = no;
        CONFIG_TPS6594_ESM = no;
        CONFIG_TPS6594_PFSM = no;
        CONFIG_NSM = no;
        CONFIG_MCHP_LAN966X_PCI = no;
        CONFIG_C2PORT = no;
        CONFIG_C2PORT_DURAMAR_2150 = no;
        CONFIG_SENSORS_LIS3_I2C = no;
        CONFIG_GENWQE = no;
        CONFIG_BCM_VK = no;
        CONFIG_MISC_ALCOR_PCI = no;
        CONFIG_MISC_RTSX_PCI = no;
        CONFIG_GP_PCI1XXXX = no;
        CONFIG_KEBA_CP500 = no;
        CONFIG_KEBA_LAN9252 = no;
        CONFIG_MISC_RP1 = no;
        CONFIG_SCSI_SAS_ATA = no;
        CONFIG_SCSI_PPA = no;
        CONFIG_SCSI_IMM = no;
        CONFIG_QEDI = no;
        CONFIG_QEDF = no;
        CONFIG_SCSI_LOWLEVEL_PCMCIA = no;
        CONFIG_PCMCIA_AHA152X = no;
        CONFIG_PCMCIA_FDOMAIN = no;
        CONFIG_PCMCIA_QLOGIC = no;
        CONFIG_PCMCIA_SYM53C500 = no;
        CONFIG_ATA = no;
        CONFIG_SATA_HOST = no;
        CONFIG_PATA_TIMINGS = no;
        CONFIG_ATA_VERBOSE_ERROR = no;
        CONFIG_ATA_FORCE = no;
        CONFIG_ATA_ACPI = no;
        # CONFIG_SATA_ZPODD is not set
        CONFIG_SATA_PMP = no;

        #
        # Controllers with non-SFF native interface
        #
        CONFIG_SATA_AHCI = no;
        CONFIG_SATA_AHCI_PLATFORM = no;
        CONFIG_AHCI_DWC = no;
        CONFIG_AHCI_CEVA = no;
        CONFIG_SATA_INIC162X = no;
        CONFIG_SATA_ACARD_AHCI = no;
        CONFIG_SATA_SIL24 = no;
        CONFIG_ATA_SFF = no;

        #
        # SFF controllers with custom DMA interface
        #
        CONFIG_PDC_ADMA = no;
        CONFIG_SATA_QSTOR = no;
        CONFIG_SATA_SX4 = no;
        CONFIG_ATA_BMDMA = no;

        #
        # SATA SFF controllers with BMDMA
        #
        CONFIG_ATA_PIIX = no;
        CONFIG_SATA_DWC = no;
        # CONFIG_SATA_DWC_OLD_DMA is not set
        CONFIG_SATA_MV = no;
        CONFIG_SATA_NV = no;
        CONFIG_SATA_PROMISE = no;
        CONFIG_SATA_SIL = no;
        CONFIG_SATA_SIS = no;
        CONFIG_SATA_SVW = no;
        CONFIG_SATA_ULI = no;
        CONFIG_SATA_VIA = no;
        CONFIG_SATA_VITESSE = no;

        #
        # PATA SFF controllers with BMDMA
        #
        CONFIG_PATA_ALI = no;
        CONFIG_PATA_AMD = no;
        CONFIG_PATA_ARTOP = no;
        CONFIG_PATA_ATIIXP = no;
        CONFIG_PATA_ATP867X = no;
        CONFIG_PATA_CMD64X = no;
        CONFIG_PATA_CYPRESS = no;
        CONFIG_PATA_EFAR = no;
        CONFIG_PATA_HPT366 = no;
        CONFIG_PATA_HPT37X = no;
        CONFIG_PATA_HPT3X2N = no;
        CONFIG_PATA_HPT3X3 = no;
        # CONFIG_PATA_HPT3X3_DMA is not set
        CONFIG_PATA_IT8213 = no;
        CONFIG_PATA_IT821X = no;
        CONFIG_PATA_JMICRON = no;
        CONFIG_PATA_MARVELL = no;
        CONFIG_PATA_NETCELL = no;
        CONFIG_PATA_NINJA32 = no;
        CONFIG_PATA_NS87415 = no;
        CONFIG_PATA_OLDPIIX = no;
        CONFIG_PATA_OPTIDMA = no;
        CONFIG_PATA_PDC2027X = no;
        CONFIG_PATA_PDC_OLD = no;
        CONFIG_PATA_RADISYS = no;
        CONFIG_PATA_RDC = no;
        CONFIG_PATA_SCH = no;
        CONFIG_PATA_SERVERWORKS = no;
        CONFIG_PATA_SIL680 = no;
        CONFIG_PATA_SIS = no;
        CONFIG_PATA_TOSHIBA = no;
        CONFIG_PATA_TRIFLEX = no;
        CONFIG_PATA_VIA = no;
        CONFIG_PATA_WINBOND = no;

        #
        # PIO-only SFF controllers
        #
        CONFIG_PATA_CMD640_PCI = no;
        CONFIG_PATA_MPIIX = no;
        CONFIG_PATA_NS87410 = no;
        CONFIG_PATA_OPTI = no;
        CONFIG_PATA_PCMCIA = no;
        CONFIG_PATA_PLATFORM = no;
        CONFIG_PATA_OF_PLATFORM = no;
        CONFIG_PATA_RZ1000 = no;
        CONFIG_PATA_PARPORT = no;

        #
        # Parallel IDE protocol modules
        #
        CONFIG_PATA_PARPORT_ATEN = no;
        CONFIG_PATA_PARPORT_BPCK = no;
        CONFIG_PATA_PARPORT_BPCK6 = no;
        CONFIG_PATA_PARPORT_COMM = no;
        CONFIG_PATA_PARPORT_DSTR = no;
        CONFIG_PATA_PARPORT_FIT2 = no;
        CONFIG_PATA_PARPORT_FIT3 = no;
        CONFIG_PATA_PARPORT_EPAT = no;
        # CONFIG_PATA_PARPORT_EPATC8 is not set
        CONFIG_PATA_PARPORT_EPIA = no;
        CONFIG_PATA_PARPORT_FRIQ = no;
        CONFIG_PATA_PARPORT_FRPW = no;
        CONFIG_PATA_PARPORT_KBIC = no;
        CONFIG_PATA_PARPORT_KTTI = no;
        CONFIG_PATA_PARPORT_ON20 = no;
        CONFIG_PATA_PARPORT_ON26 = no;

        #
        # Generic fallback / legacy drivers
        #
        CONFIG_PATA_ACPI = no;
        CONFIG_ATA_GENERIC = no;
        CONFIG_PATA_LEGACY = no;

        CONFIG_SBP_TARGET = no;

        CONFIG_FUSION = no;
        CONFIG_FUSION_SPI = no;
        CONFIG_FUSION_FC = no;
        CONFIG_FUSION_SAS = no;
        CONFIG_FUSION_CTL = no;
        CONFIG_FUSION_LAN = no;

        CONFIG_FIREWIRE = no;
        CONFIG_FIREWIRE_OHCI = no;
        CONFIG_FIREWIRE_SBP2 = no;
        CONFIG_FIREWIRE_NET = no;
        CONFIG_FIREWIRE_NOSY = no;

        CONFIG_MACINTOSH_DRIVERS = no;
        CONFIG_MAC_EMUMOUSEBTN = no;

        CONFIG_NTB_NETDEV = no;

        CONFIG_SUNGEM_PHY = no;
        CONFIG_ARCNET = no;
        CONFIG_ARCNET_1201 = no;
        CONFIG_ARCNET_1051 = no;
        CONFIG_ARCNET_RAW = no;
        CONFIG_ARCNET_CAP = no;
        CONFIG_ARCNET_COM90xx = no;
        CONFIG_ARCNET_COM90xxIO = no;
        CONFIG_ARCNET_RIM_I = no;
        CONFIG_ARCNET_COM20020 = no;
        CONFIG_ARCNET_COM20020_PCI = no;
        CONFIG_ARCNET_COM20020_CS = no;

        CONFIG_B53 = no;
        CONFIG_B53_SPI_DRIVER = no;
        CONFIG_B53_MDIO_DRIVER = no;
        CONFIG_B53_MMAP_DRIVER = no;
        CONFIG_B53_SRAB_DRIVER = no;
        CONFIG_B53_SERDES = no;
        CONFIG_NET_DSA_BCM_SF2 = no;
        CONFIG_NET_DSA_LOOP = no;
        CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK = no;
        CONFIG_NET_DSA_LANTIQ_GSWIP = no;
        CONFIG_NET_DSA_MT7530 = no;
        CONFIG_NET_DSA_MT7530_MDIO = no;
        CONFIG_NET_DSA_MT7530_MMIO = no;
        CONFIG_NET_DSA_MV88E6060 = no;
        CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON = no;
        CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C = no;
        CONFIG_NET_DSA_MICROCHIP_KSZ_SPI = no;
        # CONFIG_NET_DSA_MICROCHIP_KSZ_PTP is not set
        CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI = no;
        CONFIG_NET_DSA_MV88E6XXX = no;
        # CONFIG_NET_DSA_MV88E6XXX_PTP is not set
        CONFIG_NET_DSA_MV88E6XXX_LEDS = no;
        CONFIG_NET_DSA_MSCC_FELIX_DSA_LIB = no;
        CONFIG_NET_DSA_MSCC_OCELOT_EXT = no;
        CONFIG_NET_DSA_MSCC_SEVILLE = no;
        CONFIG_NET_DSA_AR9331 = no;
        CONFIG_NET_DSA_QCA8K = no;
        # CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT is not set
        CONFIG_NET_DSA_SJA1105 = no;
        # CONFIG_NET_DSA_SJA1105_PTP is not set
        CONFIG_NET_DSA_XRS700X = no;
        CONFIG_NET_DSA_XRS700X_I2C = no;
        CONFIG_NET_DSA_XRS700X_MDIO = no;
        CONFIG_NET_DSA_REALTEK = no;
        # CONFIG_NET_DSA_REALTEK_MDIO is not set
        # CONFIG_NET_DSA_REALTEK_SMI is not set
        CONFIG_NET_DSA_KS8995 = no;
        CONFIG_NET_DSA_SMSC_LAN9303 = no;
        CONFIG_NET_DSA_SMSC_LAN9303_I2C = no;
        CONFIG_NET_DSA_SMSC_LAN9303_MDIO = no;
        CONFIG_NET_DSA_VITESSE_VSC73XX = no;
        CONFIG_NET_DSA_VITESSE_VSC73XX_SPI = no;
        CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM = no;

        CONFIG_NET_VENDOR_3COM = no;
        CONFIG_PCMCIA_3C574 = no;
        CONFIG_PCMCIA_3C589 = no;
        CONFIG_VORTEX = no;
        CONFIG_TYPHOON = no;
        CONFIG_NET_VENDOR_ADAPTEC = no;
        CONFIG_ADAPTEC_STARFIRE = no;
        CONFIG_NET_VENDOR_AGERE = no;
        CONFIG_ET131X = no;
        CONFIG_NET_VENDOR_ALACRITECH = no;
        CONFIG_SLICOSS = no;
        CONFIG_NET_VENDOR_ALTEON = no;
        CONFIG_ACENIC = no;
        # CONFIG_ACENIC_OMIT_TIGON_I is not set
        CONFIG_ALTERA_TSE = no;
        CONFIG_NET_VENDOR_AMAZON = no;
        CONFIG_ENA_ETHERNET = no;
        CONFIG_NET_VENDOR_AMD = no;
        CONFIG_AMD8111_ETH = no;
        CONFIG_PCNET32 = no;
        CONFIG_PCMCIA_NMCLAN = no;
        CONFIG_AMD_XGBE = no;
        # CONFIG_AMD_XGBE_DCB is not set
        CONFIG_AMD_XGBE_HAVE_ECC = no;
        CONFIG_PDS_CORE = no;
        CONFIG_NET_VENDOR_AQUANTIA = no;
        CONFIG_AQTION = no;
        CONFIG_NET_VENDOR_ARC = no;
        CONFIG_NET_VENDOR_ASIX = no;
        CONFIG_SPI_AX88796C = no;
        # CONFIG_SPI_AX88796C_COMPRESSION is not set
        CONFIG_NET_VENDOR_ATHEROS = no;
        CONFIG_ATL2 = no;
        CONFIG_ATL1 = no;
        CONFIG_ATL1E = no;
        CONFIG_ATL1C = no;
        CONFIG_ALX = no;
        CONFIG_CX_ECAT = no;

        CONFIG_B44 = no;
        CONFIG_B44_PCI_AUTOSELECT = no;
        CONFIG_B44_PCICORE_AUTOSELECT = no;
        CONFIG_B44_PCI = no;
        CONFIG_BCMGENET = no;

        CONFIG_TIGON3 = no;
        CONFIG_TIGON3_HWMON = no;
        CONFIG_BNX2X = no;
        CONFIG_BNX2X_SRIOV = no;
        CONFIG_SYSTEMPORT = no;
        CONFIG_BNXT = no;
        CONFIG_BNXT_SRIOV = no;
        CONFIG_BNXT_FLOWER_OFFLOAD = no;
        # CONFIG_BNXT_DCB is not set
        CONFIG_BNXT_HWMON = no;
        CONFIG_BNGE = no;
        CONFIG_NET_VENDOR_CADENCE = no;
        CONFIG_MACB = no;
        CONFIG_MACB_USE_HWSTAMP = no;
        CONFIG_MACB_PCI = no;
        CONFIG_NET_VENDOR_CAVIUM = no;
        CONFIG_THUNDER_NIC_PF = no;
        CONFIG_THUNDER_NIC_VF = no;
        CONFIG_THUNDER_NIC_BGX = no;
        CONFIG_THUNDER_NIC_RGX = no;
        CONFIG_CAVIUM_PTP = no;
        CONFIG_LIQUIDIO_CORE = no;
        CONFIG_LIQUIDIO = no;
        CONFIG_LIQUIDIO_VF = no;

        CONFIG_CHELSIO_T1 = no;
        CONFIG_CHELSIO_T4VF = no;
        CONFIG_CHELSIO_INLINE_CRYPTO = no;
        CONFIG_CHELSIO_IPSEC_INLINE = no;
        CONFIG_CHELSIO_TLS_DEVICE = no;

        CONFIG_NET_VENDOR_CORTINA = no;
        CONFIG_GEMINI_ETHERNET = no;
        CONFIG_NET_VENDOR_DAVICOM = no;
        CONFIG_DM9051 = no;
        CONFIG_DNET = no;
        CONFIG_NET_VENDOR_DEC = no;
        CONFIG_NET_TULIP = no;
        CONFIG_DE2104X = no;
        CONFIG_TULIP = no;
        # CONFIG_TULIP_MWI is not set
        # CONFIG_TULIP_MMIO is not set
        # CONFIG_TULIP_NAPI is not set
        CONFIG_WINBOND_840 = no;
        CONFIG_DM9102 = no;
        CONFIG_ULI526X = no;
        CONFIG_PCMCIA_XIRCOM = no;
        CONFIG_NET_VENDOR_DLINK = no;
        CONFIG_DL2K = no;
        CONFIG_SUNDANCE = no;

        CONFIG_BE2NET_HWMON = no;
        CONFIG_BE2NET_BE2 = no;
        CONFIG_BE2NET_BE3 = no;
        CONFIG_BE2NET_LANCER = no;
        CONFIG_BE2NET_SKYHAWK = no;
        CONFIG_NET_VENDOR_ENGLEDER = no;
        CONFIG_TSNEP = no;
        # CONFIG_TSNEP_SELFTESTS is not set
        CONFIG_NET_VENDOR_EZCHIP = no;
        CONFIG_EZCHIP_NPS_MANAGEMENT_ENET = no;
        CONFIG_NET_VENDOR_FUJITSU = no;
        CONFIG_PCMCIA_FMVJ18X = no;
        CONFIG_NET_VENDOR_FUNGIBLE = no;
        CONFIG_FUN_CORE = no;
        CONFIG_FUN_ETH = no;
        CONFIG_NET_VENDOR_GOOGLE = no;
        CONFIG_GVE = no;
        CONFIG_NET_VENDOR_HISILICON = no;
        CONFIG_HIBMCGE = no;
        CONFIG_NET_VENDOR_HUAWEI = no;
        CONFIG_HINIC = no;
        CONFIG_HINIC3 = no;
        CONFIG_NET_VENDOR_I825XX = no;

        CONFIG_JME = no;
        CONFIG_NET_VENDOR_ADI = no;
        CONFIG_ADIN1110 = no;
        CONFIG_NET_VENDOR_LITEX = no;
        CONFIG_LITEX_LITEETH = no;
        CONFIG_NET_VENDOR_MARVELL = no;
        CONFIG_MVMDIO = no;
        CONFIG_SKGE = no;
        # CONFIG_SKGE_DEBUG is not set
        # CONFIG_SKGE_GENESIS is not set
        CONFIG_SKY2 = no;
        # CONFIG_SKY2_DEBUG is not set
        CONFIG_OCTEON_EP = no;
        CONFIG_OCTEON_EP_VF = no;
        CONFIG_PRESTERA = no;
        CONFIG_PRESTERA_PCI = no;

        CONFIG_MLX4_EN = no;
        CONFIG_MLX4_EN_DCB = no;

        CONFIG_MLX4_DEBUG = no;
        CONFIG_MLX4_CORE_GEN2 = no;
        CONFIG_MLX5_CORE = no;
        # CONFIG_MLX5_FPGA is not set
        CONFIG_MLX5_CORE_EN = no;
        CONFIG_MLX5_EN_ARFS = no;
        CONFIG_MLX5_EN_RXNFC = no;
        CONFIG_MLX5_MPFS = no;
        CONFIG_MLX5_ESWITCH = no;
        CONFIG_MLX5_BRIDGE = no;
        CONFIG_MLX5_CORE_EN_DCB = no;
        # CONFIG_MLX5_CORE_IPOIB is not set
        # CONFIG_MLX5_MACSEC is not set
        # CONFIG_MLX5_EN_IPSEC is not set
        # CONFIG_MLX5_EN_TLS is not set
        CONFIG_MLX5_SW_STEERING = no;
        CONFIG_MLX5_HW_STEERING = no;
        # CONFIG_MLX5_SF is not set
        CONFIG_MLX5_DPLL = no;
        CONFIG_MLXSW_CORE = no;
        CONFIG_MLXSW_CORE_HWMON = no;
        CONFIG_MLXSW_CORE_THERMAL = no;
        CONFIG_MLXSW_PCI = no;
        CONFIG_MLXSW_I2C = no;
        CONFIG_MLXSW_SPECTRUM = no;
        CONFIG_MLXSW_SPECTRUM_DCB = no;
        CONFIG_MLXSW_MINIMAL = no;
        CONFIG_MLXFW = no;
        CONFIG_NET_VENDOR_META = no;
        CONFIG_FBNIC = no;
        CONFIG_NET_VENDOR_MICREL = no;
        CONFIG_KS8842 = no;
        CONFIG_KS8851 = no;
        CONFIG_KS8851_MLL = no;
        CONFIG_KSZ884X_PCI = no;
        CONFIG_NET_VENDOR_MICROCHIP = no;
        CONFIG_ENC28J60 = no;
        # CONFIG_ENC28J60_WRITEVERIFY is not set
        CONFIG_ENCX24J600 = no;
        CONFIG_LAN743X = no;
        CONFIG_LAN865X = no;
        CONFIG_LAN966X_SWITCH = no;
        CONFIG_LAN966X_DCB = no;
        CONFIG_VCAP = no;
        CONFIG_FDMA = no;
        CONFIG_NET_VENDOR_MICROSEMI = no;
        CONFIG_MSCC_OCELOT_SWITCH_LIB = no;
        CONFIG_MSCC_OCELOT_SWITCH = no;
        CONFIG_NET_VENDOR_MICROSOFT = no;
        CONFIG_MICROSOFT_MANA = no;
        CONFIG_NET_VENDOR_MYRI = no;
        CONFIG_MYRI10GE = no;
        CONFIG_MYRI10GE_DCA = no;
        CONFIG_FEALNX = no;
        CONFIG_NET_VENDOR_NI = no;
        CONFIG_NI_XGE_MANAGEMENT_ENET = no;
        CONFIG_NET_VENDOR_NATSEMI = no;
        CONFIG_NATSEMI = no;
        CONFIG_NS83820 = no;
        CONFIG_NET_VENDOR_NETERION = no;
        CONFIG_S2IO = no;
        CONFIG_NET_VENDOR_NETRONOME = no;
        CONFIG_NFP = no;
        CONFIG_NFP_APP_FLOWER = no;
        CONFIG_NFP_APP_ABM_NIC = no;
        CONFIG_NFP_NET_IPSEC = no;
        # CONFIG_NFP_DEBUG is not set
        CONFIG_NET_VENDOR_8390 = no;
        CONFIG_PCMCIA_AXNET = no;
        CONFIG_NE2K_PCI = no;
        CONFIG_PCMCIA_PCNET = no;
        CONFIG_NET_VENDOR_NVIDIA = no;
        CONFIG_FORCEDETH = no;
        CONFIG_NET_VENDOR_OKI = no;
        CONFIG_ETHOC = no;
        CONFIG_OA_TC6 = no;
        CONFIG_NET_VENDOR_PACKET_ENGINES = no;
        CONFIG_HAMACHI = no;
        CONFIG_YELLOWFIN = no;
        CONFIG_NET_VENDOR_PENSANDO = no;
        CONFIG_IONIC = no;
        CONFIG_NET_VENDOR_QLOGIC = no;
        CONFIG_QLA3XXX = no;
        CONFIG_QLCNIC = no;
        CONFIG_QLCNIC_SRIOV = no;
        CONFIG_QLCNIC_DCB = no;
        CONFIG_QLCNIC_HWMON = no;
        CONFIG_NETXEN_NIC = no;
        CONFIG_QED = no;
        CONFIG_QED_LL2 = no;
        CONFIG_QED_SRIOV = no;
        CONFIG_QEDE = no;
        CONFIG_QED_RDMA = no;
        CONFIG_QED_ISCSI = no;
        CONFIG_QED_FCOE = no;
        CONFIG_QED_OOO = no;
        CONFIG_NET_VENDOR_BROCADE = no;
        CONFIG_BNA = no;
        CONFIG_NET_VENDOR_QUALCOMM = no;
        CONFIG_QCA7000 = no;
        CONFIG_QCA7000_SPI = no;
        CONFIG_QCA7000_UART = no;
        CONFIG_QCOM_EMAC = no;
        CONFIG_RMNET = no;
        CONFIG_NET_VENDOR_RDC = no;
        CONFIG_R6040 = no;
        CONFIG_NET_VENDOR_REALTEK = no;
        CONFIG_ATP = no;
        CONFIG_8139CP = no;
        CONFIG_8139TOO = no;
        # CONFIG_8139TOO_PIO is not set
        # CONFIG_8139TOO_TUNE_TWISTER is not set
        CONFIG_8139TOO_8129 = no;
        # CONFIG_8139_OLD_RX_RESET is not set
        CONFIG_R8169 = no;
        # CONFIG_R8169_LEDS is not set
        CONFIG_RTASE = no;
        CONFIG_NET_VENDOR_RENESAS = no;
        CONFIG_NET_VENDOR_ROCKER = no;
        CONFIG_ROCKER = no;
        CONFIG_NET_VENDOR_SAMSUNG = no;
        CONFIG_SXGBE_ETH = no;
        CONFIG_NET_VENDOR_SEEQ = no;
        CONFIG_NET_VENDOR_SILAN = no;
        CONFIG_SC92031 = no;
        CONFIG_NET_VENDOR_SIS = no;
        CONFIG_SIS900 = no;
        CONFIG_SIS190 = no;
        CONFIG_NET_VENDOR_SOLARFLARE = no;
        CONFIG_SFC = no;
        CONFIG_SFC_MTD = no;
        CONFIG_SFC_MCDI_MON = no;
        CONFIG_SFC_SRIOV = no;
        CONFIG_SFC_MCDI_LOGGING = no;
        CONFIG_SFC_FALCON = no;
        CONFIG_SFC_FALCON_MTD = no;
        CONFIG_SFC_SIENA = no;
        CONFIG_SFC_SIENA_MTD = no;
        CONFIG_SFC_SIENA_MCDI_MON = no;
        # CONFIG_SFC_SIENA_SRIOV is not set
        CONFIG_SFC_SIENA_MCDI_LOGGING = no;
        CONFIG_NET_VENDOR_SMSC = no;
        CONFIG_PCMCIA_SMC91C92 = no;
        CONFIG_EPIC100 = no;
        CONFIG_SMSC911X = no;
        CONFIG_SMSC9420 = no;
        CONFIG_NET_VENDOR_SOCIONEXT = no;
        CONFIG_NET_VENDOR_STMICRO = no;
        CONFIG_STMMAC_ETH = no;
        # CONFIG_STMMAC_SELFTESTS is not set
        CONFIG_STMMAC_PLATFORM = no;
        CONFIG_DWMAC_DWC_QOS_ETH = no;
        CONFIG_DWMAC_GENERIC = no;
        CONFIG_DWMAC_INTEL_PLAT = no;
        CONFIG_DWMAC_INTEL = no;
        CONFIG_STMMAC_PCI = no;
        CONFIG_NET_VENDOR_SUN = no;
        CONFIG_HAPPYMEAL = no;
        CONFIG_SUNGEM = no;
        CONFIG_CASSINI = no;
        CONFIG_NIU = no;
        CONFIG_NET_VENDOR_SYNOPSYS = no;
        CONFIG_DWC_XLGMAC = no;
        CONFIG_DWC_XLGMAC_PCI = no;
        CONFIG_NET_VENDOR_TEHUTI = no;
        CONFIG_TEHUTI = no;
        CONFIG_TEHUTI_TN40 = no;
        CONFIG_NET_VENDOR_TI = no;
        # CONFIG_TI_CPSW_PHY_SEL is not set
        CONFIG_TLAN = no;
        CONFIG_NET_VENDOR_VERTEXCOM = no;
        CONFIG_MSE102X = no;
        CONFIG_NET_VENDOR_VIA = no;
        CONFIG_VIA_RHINE = no;
        # CONFIG_VIA_RHINE_MMIO is not set
        CONFIG_VIA_VELOCITY = no;
        CONFIG_NET_VENDOR_WANGXUN = no;
        CONFIG_LIBWX = no;
        CONFIG_NGBE = no;
        CONFIG_TXGBE = no;
        CONFIG_TXGBEVF = no;
        CONFIG_NGBEVF = no;
        CONFIG_NET_VENDOR_WIZNET = no;
        CONFIG_WIZNET_W5100 = no;
        CONFIG_WIZNET_W5300 = no;
        # CONFIG_WIZNET_BUS_DIRECT is not set
        # CONFIG_WIZNET_BUS_INDIRECT is not set
        CONFIG_WIZNET_BUS_ANY = no;
        CONFIG_WIZNET_W5100_SPI = no;
        CONFIG_NET_VENDOR_XILINX = no;
        CONFIG_XILINX_EMACLITE = no;
        CONFIG_XILINX_AXI_EMAC = no;
        CONFIG_XILINX_LL_TEMAC = no;
        CONFIG_NET_VENDOR_XIRCOM = no;
        CONFIG_PCMCIA_XIRC2PS = no;
        CONFIG_FDDI = no;
        CONFIG_DEFXX = no;
        CONFIG_SKFP = no;
        CONFIG_HIPPI = no;
        CONFIG_ROADRUNNER = no;

        CONFIG_PHYLIB_LEDS = no;
        CONFIG_QCA807X_PHY = no;

        CONFIG_CAN_NETLINK = no;
        CONFIG_CAN_CALC_BITTIMING = no;
        CONFIG_CAN_RX_OFFLOAD = no;
        CONFIG_CAN_CAN327 = no;
        CONFIG_CAN_FLEXCAN = no;
        CONFIG_CAN_GRCAN = no;
        CONFIG_CAN_JANZ_ICAN3 = no;
        CONFIG_CAN_KVASER_PCIEFD = no;
        CONFIG_CAN_SLCAN = no;
        CONFIG_CAN_C_CAN = no;
        CONFIG_CAN_C_CAN_PLATFORM = no;
        CONFIG_CAN_C_CAN_PCI = no;
        CONFIG_CAN_CC770 = no;
        CONFIG_CAN_CC770_ISA = no;
        CONFIG_CAN_CC770_PLATFORM = no;
        CONFIG_CAN_CTUCANFD = no;
        CONFIG_CAN_CTUCANFD_PCI = no;
        CONFIG_CAN_CTUCANFD_PLATFORM = no;
        CONFIG_CAN_ESD_402_PCI = no;
        CONFIG_CAN_IFI_CANFD = no;
        CONFIG_CAN_M_CAN = no;
        CONFIG_CAN_M_CAN_PCI = no;
        CONFIG_CAN_M_CAN_PLATFORM = no;
        CONFIG_CAN_M_CAN_TCAN4X5X = no;
        CONFIG_CAN_PEAK_PCIEFD = no;
        CONFIG_CAN_SJA1000 = no;
        CONFIG_CAN_EMS_PCI = no;
        CONFIG_CAN_EMS_PCMCIA = no;
        CONFIG_CAN_F81601 = no;
        CONFIG_CAN_KVASER_PCI = no;
        CONFIG_CAN_PEAK_PCI = no;
        CONFIG_CAN_PEAK_PCIEC = no;
        CONFIG_CAN_PEAK_PCMCIA = no;
        CONFIG_CAN_PLX_PCI = no;
        CONFIG_CAN_SJA1000_ISA = no;
        CONFIG_CAN_SJA1000_PLATFORM = no;
        CONFIG_CAN_SOFTING = no;
        CONFIG_CAN_SOFTING_CS = no;

        #
        # CAN SPI interfaces
        #
        CONFIG_CAN_HI311X = no;
        CONFIG_CAN_MCP251X = no;
        CONFIG_CAN_MCP251XFD = no;
        # CONFIG_CAN_MCP251XFD_SANITY is not set
        # end of CAN SPI interfaces

        #
        # CAN USB interfaces
        #
        CONFIG_CAN_8DEV_USB = no;
        CONFIG_CAN_EMS_USB = no;
        CONFIG_CAN_ESD_USB = no;
        CONFIG_CAN_ETAS_ES58X = no;
        CONFIG_CAN_F81604 = no;
        CONFIG_CAN_GS_USB = no;
        CONFIG_CAN_KVASER_USB = no;
        CONFIG_CAN_MCBA_USB = no;
        CONFIG_CAN_NCT6694 = no;
        CONFIG_CAN_PEAK_USB = no;
        CONFIG_CAN_UCAN = no;
        # end of CAN USB interfaces

        CONFIG_MDIO_BITBANG = no;
        CONFIG_MDIO_BCM_UNIMAC = no;
        CONFIG_MDIO_CAVIUM = no;
        CONFIG_MDIO_GPIO = no;
        CONFIG_MDIO_HISI_FEMAC = no;
        CONFIG_MDIO_MVUSB = no;
        CONFIG_MDIO_MSCC_MIIM = no;
        CONFIG_MDIO_OCTEON = no;
        CONFIG_MDIO_IPQ4019 = no;
        CONFIG_MDIO_IPQ8064 = no;
        CONFIG_MDIO_REGMAP = no;
        CONFIG_MDIO_THUNDER = no;
        CONFIG_MDIO_BUS_MUX = no;
        CONFIG_MDIO_BUS_MUX_GPIO = no;
        CONFIG_MDIO_BUS_MUX_MULTIPLEXER = no;
        CONFIG_MDIO_BUS_MUX_MMIOREG = no;
        CONFIG_PCS_XPCS = no;
        CONFIG_PCS_LYNX = no;
        CONFIG_PCS_MTK_LYNXI = no;
        CONFIG_PLIP = no;

        CONFIG_WLAN_VENDOR_ADMTEK = no;
        CONFIG_ADM8211 = no;
        CONFIG_ATH_COMMON = no;
        CONFIG_WLAN_VENDOR_ATH = no;
        # CONFIG_ATH_DEBUG is not set
        # CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS is not set
        CONFIG_ATH5K = no;
        # CONFIG_ATH5K_DEBUG is not set
        # CONFIG_ATH5K_TRACER is not set
        CONFIG_ATH5K_PCI = no;
        # CONFIG_ATH5K_TEST_CHANNELS is not set
        CONFIG_ATH9K_HW = no;
        CONFIG_ATH9K_COMMON = no;
        CONFIG_ATH9K_BTCOEX_SUPPORT = no;
        CONFIG_ATH9K = no;
        CONFIG_ATH9K_PCI = no;
        CONFIG_ATH9K_AHB = no;
        # CONFIG_ATH9K_DEBUGFS is not set
        CONFIG_ATH9K_DFS_CERTIFIED = no;
        # CONFIG_ATH9K_DYNACK is not set
        # CONFIG_ATH9K_WOW is not set
        CONFIG_ATH9K_RFKILL = no;
        # CONFIG_ATH9K_CHANNEL_CONTEXT is not set
        CONFIG_ATH9K_PCOEM = no;
        CONFIG_ATH9K_PCI_NO_EEPROM = no;
        CONFIG_ATH9K_HTC = no;
        # CONFIG_ATH9K_HTC_DEBUGFS is not set
        # CONFIG_ATH9K_HWRNG is not set
        CONFIG_CARL9170 = no;
        CONFIG_CARL9170_LEDS = no;
        # CONFIG_CARL9170_DEBUGFS is not set
        CONFIG_CARL9170_WPC = no;
        # CONFIG_CARL9170_HWRNG is not set
        CONFIG_ATH6KL = no;
        CONFIG_ATH6KL_SDIO = no;
        CONFIG_ATH6KL_USB = no;
        # CONFIG_ATH6KL_DEBUG is not set
        # CONFIG_ATH6KL_TRACING is not set
        # CONFIG_ATH6KL_REGDOMAIN is not set
        CONFIG_AR5523 = no;
        CONFIG_WIL6210 = no;
        CONFIG_WIL6210_ISR_COR = no;
        # CONFIG_WIL6210_TRACING is not set
        CONFIG_WIL6210_DEBUGFS = no;
        CONFIG_ATH10K = no;
        CONFIG_ATH10K_CE = no;
        CONFIG_ATH10K_PCI = no;
        # CONFIG_ATH10K_AHB is not set
        CONFIG_ATH10K_SDIO = no;
        CONFIG_ATH10K_USB = no;
        # CONFIG_ATH10K_DEBUG is not set
        # CONFIG_ATH10K_DEBUGFS is not set
        CONFIG_ATH10K_LEDS = no;
        # CONFIG_ATH10K_TRACING is not set
        CONFIG_ATH10K_DFS_CERTIFIED = no;
        CONFIG_WCN36XX = no;
        # CONFIG_WCN36XX_DEBUGFS is not set
        CONFIG_ATH11K = no;
        CONFIG_ATH11K_PCI = no;
        # CONFIG_ATH11K_DEBUG is not set
        # CONFIG_ATH11K_DEBUGFS is not set
        # CONFIG_ATH11K_TRACING is not set
        CONFIG_ATH12K = no;
        # CONFIG_ATH12K_DEBUG is not set
        # CONFIG_ATH12K_DEBUGFS is not set
        # CONFIG_ATH12K_TRACING is not set
        # CONFIG_ATH12K_COREDUMP is not set
        CONFIG_WLAN_VENDOR_ATMEL = no;
        CONFIG_AT76C50X_USB = no;
        CONFIG_WLAN_VENDOR_BROADCOM = no;
        CONFIG_B43 = no;
        CONFIG_B43_BCMA = no;
        CONFIG_B43_SSB = no;
        CONFIG_B43_BUSES_BCMA_AND_SSB = no;
        # CONFIG_B43_BUSES_BCMA is not set
        # CONFIG_B43_BUSES_SSB is not set
        CONFIG_B43_PCI_AUTOSELECT = no;
        CONFIG_B43_PCICORE_AUTOSELECT = no;
        # CONFIG_B43_SDIO is not set
        CONFIG_B43_BCMA_PIO = no;
        CONFIG_B43_PIO = no;
        CONFIG_B43_PHY_G = no;
        CONFIG_B43_PHY_N = no;
        CONFIG_B43_PHY_LP = no;
        CONFIG_B43_PHY_HT = no;
        CONFIG_B43_LEDS = no;
        CONFIG_B43_HWRNG = no;
        # CONFIG_B43_DEBUG is not set
        CONFIG_B43LEGACY = no;
        CONFIG_B43LEGACY_PCI_AUTOSELECT = no;
        CONFIG_B43LEGACY_PCICORE_AUTOSELECT = no;
        CONFIG_B43LEGACY_LEDS = no;
        CONFIG_B43LEGACY_HWRNG = no;
        CONFIG_B43LEGACY_DEBUG = no;
        CONFIG_B43LEGACY_DMA = no;
        CONFIG_B43LEGACY_PIO = no;
        CONFIG_B43LEGACY_DMA_AND_PIO_MODE = no;
        # CONFIG_B43LEGACY_DMA_MODE is not set
        # CONFIG_B43LEGACY_PIO_MODE is not set
        CONFIG_BRCMUTIL = no;
        CONFIG_BRCMSMAC = no;
        CONFIG_BRCMFMAC = no;
        CONFIG_BRCMFMAC_PROTO_BCDC = no;
        CONFIG_BRCMFMAC_PROTO_MSGBUF = no;
        CONFIG_BRCMFMAC_SDIO = no;
        CONFIG_BRCMFMAC_USB = no;
        CONFIG_BRCMFMAC_PCIE = no;

        CONFIG_IPW2100 = no;
        CONFIG_IPW2100_MONITOR = no;
        # CONFIG_IPW2100_DEBUG is not set
        CONFIG_IPW2200 = no;
        CONFIG_IPW2200_MONITOR = no;
        # CONFIG_IPW2200_RADIOTAP is not set
        # CONFIG_IPW2200_PROMISCUOUS is not set
        # CONFIG_IPW2200_QOS is not set
        # CONFIG_IPW2200_DEBUG is not set
        CONFIG_LIBIPW = no;
        # CONFIG_LIBIPW_DEBUG is not set
        CONFIG_IWLEGACY = no;
        CONFIG_IWL4965 = no;
        CONFIG_IWL3945 = no;

        #
        # iwl3945 / iwl4965 Debugging Options
        #
        # CONFIG_IWLEGACY_DEBUG is not set
        # CONFIG_IWLEGACY_DEBUGFS is not set
        # end of iwl3945 / iwl4965 Debugging Options

        CONFIG_WLAN_VENDOR_INTERSIL = no;
        CONFIG_P54_COMMON = no;
        CONFIG_P54_USB = no;
        CONFIG_P54_PCI = no;
        CONFIG_P54_SPI = no;
        # CONFIG_P54_SPI_DEFAULT_EEPROM is not set
        CONFIG_P54_LEDS = no;
        CONFIG_WLAN_VENDOR_MARVELL = no;
        CONFIG_LIBERTAS = no;
        CONFIG_LIBERTAS_USB = no;
        CONFIG_LIBERTAS_SDIO = no;
        CONFIG_LIBERTAS_SPI = no;
        # CONFIG_LIBERTAS_DEBUG is not set
        # CONFIG_LIBERTAS_MESH is not set
        CONFIG_LIBERTAS_THINFIRM = no;
        # CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
        CONFIG_LIBERTAS_THINFIRM_USB = no;
        CONFIG_MWIFIEX = no;
        CONFIG_MWIFIEX_SDIO = no;
        CONFIG_MWIFIEX_PCIE = no;
        CONFIG_MWIFIEX_USB = no;
        CONFIG_MWL8K = no;
        CONFIG_WLAN_VENDOR_MEDIATEK = no;
        CONFIG_MT7601U = no;
        CONFIG_MT76_CORE = no;
        CONFIG_MT76_LEDS = no;
        CONFIG_MT76_USB = no;
        CONFIG_MT76_SDIO = no;
        CONFIG_MT76x02_LIB = no;
        CONFIG_MT76x02_USB = no;
        CONFIG_MT76_CONNAC_LIB = no;
        CONFIG_MT792x_LIB = no;
        CONFIG_MT792x_USB = no;
        CONFIG_MT76x0_COMMON = no;
        CONFIG_MT76x0U = no;
        CONFIG_MT76x0E = no;
        CONFIG_MT76x2_COMMON = no;
        CONFIG_MT76x2E = no;
        CONFIG_MT76x2U = no;
        CONFIG_MT7603E = no;
        CONFIG_MT7615_COMMON = no;
        CONFIG_MT7615E = no;
        CONFIG_MT7663_USB_SDIO_COMMON = no;
        CONFIG_MT7663U = no;
        CONFIG_MT7663S = no;
        CONFIG_MT7915E = no;
        CONFIG_MT7921_COMMON = no;
        CONFIG_MT7921E = no;
        CONFIG_MT7921S = no;
        CONFIG_MT7921U = no;
        CONFIG_MT7996E = no;
        CONFIG_MT7925_COMMON = no;
        CONFIG_MT7925E = no;
        CONFIG_MT7925U = no;
        CONFIG_WLAN_VENDOR_MICROCHIP = no;
        CONFIG_WILC1000 = no;
        CONFIG_WILC1000_SDIO = no;
        CONFIG_WILC1000_SPI = no;
        # CONFIG_WILC1000_HW_OOB_INTR is not set
        CONFIG_WLAN_VENDOR_PURELIFI = no;
        CONFIG_PLFXLC = no;
        CONFIG_WLAN_VENDOR_RALINK = no;
        CONFIG_RT2X00 = no;
        CONFIG_RT2400PCI = no;
        CONFIG_RT2500PCI = no;
        CONFIG_RT61PCI = no;
        CONFIG_RT2800PCI = no;
        CONFIG_RT2800PCI_RT33XX = no;
        CONFIG_RT2800PCI_RT35XX = no;
        CONFIG_RT2800PCI_RT53XX = no;
        CONFIG_RT2800PCI_RT3290 = no;
        CONFIG_RT2500USB = no;
        CONFIG_RT73USB = no;
        CONFIG_RT2800USB = no;
        CONFIG_RT2800USB_RT33XX = no;
        CONFIG_RT2800USB_RT35XX = no;
        # CONFIG_RT2800USB_RT3573 is not set
        CONFIG_RT2800USB_RT53XX = no;
        CONFIG_RT2800USB_RT55XX = no;
        # CONFIG_RT2800USB_UNKNOWN is not set
        CONFIG_RT2800_LIB = no;
        CONFIG_RT2800_LIB_MMIO = no;
        CONFIG_RT2X00_LIB_MMIO = no;
        CONFIG_RT2X00_LIB_PCI = no;
        CONFIG_RT2X00_LIB_USB = no;
        CONFIG_RT2X00_LIB = no;
        CONFIG_RT2X00_LIB_FIRMWARE = no;
        CONFIG_RT2X00_LIB_CRYPTO = no;
        CONFIG_RT2X00_LIB_LEDS = no;
        # CONFIG_RT2X00_LIB_DEBUGFS is not set
        # CONFIG_RT2X00_DEBUG is not set
        CONFIG_WLAN_VENDOR_REALTEK = no;
        CONFIG_RTL8180 = no;
        CONFIG_RTL8187 = no;
        CONFIG_RTL8187_LEDS = no;
        CONFIG_RTL_CARDS = no;
        CONFIG_RTL8192CE = no;
        CONFIG_RTL8192SE = no;
        CONFIG_RTL8192DE = no;
        CONFIG_RTL8723AE = no;
        CONFIG_RTL8723BE = no;
        CONFIG_RTL8188EE = no;
        CONFIG_RTL8192EE = no;
        CONFIG_RTL8821AE = no;
        CONFIG_RTL8192CU = no;
        CONFIG_RTL8192DU = no;
        CONFIG_RTLWIFI = no;
        CONFIG_RTLWIFI_PCI = no;
        CONFIG_RTLWIFI_USB = no;
        CONFIG_RTLWIFI_DEBUG = no;
        CONFIG_RTL8192C_COMMON = no;
        CONFIG_RTL8192D_COMMON = no;
        CONFIG_RTL8723_COMMON = no;
        CONFIG_RTLBTCOEXIST = no;
        CONFIG_RTL8XXXU = no;
        CONFIG_RTL8XXXU_UNTESTED = no;
        CONFIG_RTW88 = no;
        CONFIG_RTW88_CORE = no;
        CONFIG_RTW88_PCI = no;
        CONFIG_RTW88_SDIO = no;
        CONFIG_RTW88_USB = no;
        CONFIG_RTW88_8822B = no;
        CONFIG_RTW88_8822C = no;
        CONFIG_RTW88_8723X = no;
        CONFIG_RTW88_8703B = no;
        CONFIG_RTW88_8723D = no;
        CONFIG_RTW88_8821C = no;
        CONFIG_RTW88_88XXA = no;
        CONFIG_RTW88_8821A = no;
        CONFIG_RTW88_8812A = no;
        CONFIG_RTW88_8814A = no;
        CONFIG_RTW88_8822BE = no;
        CONFIG_RTW88_8822BS = no;
        CONFIG_RTW88_8822BU = no;
        CONFIG_RTW88_8822CE = no;
        CONFIG_RTW88_8822CS = no;
        CONFIG_RTW88_8822CU = no;
        CONFIG_RTW88_8723DE = no;
        CONFIG_RTW88_8723DS = no;
        CONFIG_RTW88_8723CS = no;
        CONFIG_RTW88_8723DU = no;
        CONFIG_RTW88_8821CE = no;
        CONFIG_RTW88_8821CS = no;
        CONFIG_RTW88_8821CU = no;
        CONFIG_RTW88_8821AU = no;
        CONFIG_RTW88_8812AU = no;
        CONFIG_RTW88_8814AE = no;
        CONFIG_RTW88_8814AU = no;
        # CONFIG_RTW88_DEBUG is not set
        # CONFIG_RTW88_DEBUGFS is not set
        CONFIG_RTW88_LEDS = no;
        CONFIG_RTW89 = no;
        CONFIG_RTW89_CORE = no;
        CONFIG_RTW89_PCI = no;
        CONFIG_RTW89_USB = no;
        CONFIG_RTW89_8851B = no;
        CONFIG_RTW89_8852A = no;
        CONFIG_RTW89_8852B_COMMON = no;
        CONFIG_RTW89_8852B = no;
        CONFIG_RTW89_8852BT = no;
        CONFIG_RTW89_8852C = no;
        CONFIG_RTW89_8922A = no;
        CONFIG_RTW89_8851BE = no;
        CONFIG_RTW89_8851BU = no;
        CONFIG_RTW89_8852AE = no;
        CONFIG_RTW89_8852BE = no;
        CONFIG_RTW89_8852BU = no;
        CONFIG_RTW89_8852BTE = no;
        CONFIG_RTW89_8852CE = no;
        CONFIG_RTW89_8922AE = no;
        # CONFIG_RTW89_DEBUGMSG is not set
        # CONFIG_RTW89_DEBUGFS is not set
        CONFIG_WLAN_VENDOR_RSI = no;
        CONFIG_RSI_91X = no;
        CONFIG_RSI_DEBUGFS = no;
        CONFIG_RSI_SDIO = no;
        CONFIG_RSI_USB = no;
        CONFIG_RSI_COEX = no;
        CONFIG_WLAN_VENDOR_SILABS = no;
        CONFIG_WFX = no;
        CONFIG_WLAN_VENDOR_ST = no;
        CONFIG_CW1200 = no;
        CONFIG_CW1200_WLAN_SDIO = no;
        CONFIG_CW1200_WLAN_SPI = no;
        CONFIG_WLAN_VENDOR_TI = no;
        CONFIG_WL1251 = no;
        CONFIG_WL1251_SPI = no;
        CONFIG_WL1251_SDIO = no;
        CONFIG_WL12XX = no;
        CONFIG_WL18XX = no;
        CONFIG_WLCORE = no;
        CONFIG_WLCORE_SPI = no;
        CONFIG_WLCORE_SDIO = no;
        CONFIG_WLAN_VENDOR_ZYDAS = no;
        CONFIG_ZD1211RW = no;
        # CONFIG_ZD1211RW_DEBUG is not set
        CONFIG_WLAN_VENDOR_QUANTENNA = no;
        CONFIG_QTNFMAC = no;
        CONFIG_QTNFMAC_PCIE = no;
        CONFIG_MAC80211_HWSIM = no;
        CONFIG_VIRT_WIFI = no;
        CONFIG_WAN = no;
        CONFIG_HDLC = no;
        CONFIG_HDLC_RAW = no;
        CONFIG_HDLC_RAW_ETH = no;
        CONFIG_HDLC_CISCO = no;
        CONFIG_HDLC_FR = no;
        CONFIG_HDLC_PPP = no;
        CONFIG_HDLC_X25 = no;
        CONFIG_FRAMER = no;
        CONFIG_GENERIC_FRAMER = no;
        CONFIG_FRAMER_PEF2256 = no;
        CONFIG_PCI200SYN = no;
        CONFIG_WANXL = no;
        CONFIG_PC300TOO = no;
        CONFIG_FARSYNC = no;
        CONFIG_LAPBETHER = no;

        CONFIG_FUJITSU_ES = no;

        CONFIG_HYPERV_NET = no;

        CONFIG_KEYBOARD_ADC = no;
        CONFIG_KEYBOARD_ADP5585 = no;
        CONFIG_KEYBOARD_ADP5588 = no;
        CONFIG_KEYBOARD_APPLESPI = no;
        CONFIG_KEYBOARD_ATKBD = no;
        CONFIG_KEYBOARD_QT1050 = no;
        CONFIG_KEYBOARD_QT1070 = no;
        CONFIG_KEYBOARD_QT2160 = no;
        CONFIG_KEYBOARD_DLINK_DIR685 = no;
        CONFIG_KEYBOARD_LKKBD = no;

        CONFIG_KEYBOARD_TCA8418 = no;

        CONFIG_KEYBOARD_LM8323 = no;
        CONFIG_KEYBOARD_LM8333 = no;
        CONFIG_KEYBOARD_MAX7359 = no;
        CONFIG_KEYBOARD_MAX7360 = no;
        CONFIG_KEYBOARD_MPR121 = no;
        CONFIG_KEYBOARD_NEWTON = no;
        CONFIG_KEYBOARD_OPENCORES = no;
        CONFIG_KEYBOARD_PINEPHONE = no;
        CONFIG_KEYBOARD_SAMSUNG = no;
        CONFIG_KEYBOARD_STOWAWAY = no;
        CONFIG_KEYBOARD_SUNKBD = no;
        CONFIG_KEYBOARD_STMPE = no;
        CONFIG_KEYBOARD_IQS62X = no;
        CONFIG_KEYBOARD_OMAP4 = no;
        CONFIG_KEYBOARD_TM2_TOUCHKEY = no;
        CONFIG_KEYBOARD_XTKBD = no;
        CONFIG_KEYBOARD_CROS_EC = no;
        CONFIG_KEYBOARD_CAP11XX = no;
        CONFIG_KEYBOARD_BCM = no;
        CONFIG_KEYBOARD_MTK_PMIC = no;
        CONFIG_KEYBOARD_CYPRESS_SF = no;

        CONFIG_MOUSE_PS2 = no;
        CONFIG_MOUSE_PS2_ALPS = no;
        CONFIG_MOUSE_PS2_BYD = no;
        CONFIG_MOUSE_PS2_LOGIPS2PP = no;
        CONFIG_MOUSE_PS2_SYNAPTICS = no;
        CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS = no;
        CONFIG_MOUSE_PS2_CYPRESS = no;
        CONFIG_MOUSE_PS2_LIFEBOOK = no;
        CONFIG_MOUSE_PS2_TRACKPOINT = no;
        CONFIG_MOUSE_PS2_ELANTECH = no;
        CONFIG_MOUSE_PS2_ELANTECH_SMBUS = no;
        # CONFIG_MOUSE_PS2_SENTELIC is not set
        # CONFIG_MOUSE_PS2_TOUCHKIT is not set
        CONFIG_MOUSE_PS2_FOCALTECH = no;
        CONFIG_MOUSE_PS2_VMMOUSE = no;
        CONFIG_MOUSE_PS2_SMBUS = no;

        CONFIG_MOUSE_APPLETOUCH = no;
        CONFIG_MOUSE_BCM5974 = no;
        CONFIG_MOUSE_CYAPA = no;
        CONFIG_MOUSE_ELAN_I2C = no;
        CONFIG_MOUSE_ELAN_I2C_I2C = no;
        CONFIG_MOUSE_ELAN_I2C_SMBUS = no;
        CONFIG_MOUSE_VSXXXAA = no;
        CONFIG_JOYSTICK_ADC = no;
        CONFIG_JOYSTICK_DB9 = no;
        CONFIG_JOYSTICK_GAMECON = no;
        CONFIG_JOYSTICK_TURBOGRAFX = no;
        CONFIG_JOYSTICK_WALKERA0701 = no;

        CONFIG_INPUT_TABLET = no;
        CONFIG_TABLET_USB_ACECAD = no;
        CONFIG_TABLET_USB_AIPTEK = no;
        CONFIG_TABLET_USB_HANWANG = no;
        CONFIG_TABLET_USB_KBTAB = no;
        CONFIG_TABLET_USB_PEGASUS = no;
        CONFIG_TABLET_SERIAL_WACOM4 = no;
        CONFIG_INPUT_TOUCHSCREEN = no;
        CONFIG_TOUCHSCREEN_ADS7846 = no;
        CONFIG_TOUCHSCREEN_AD7877 = no;
        CONFIG_TOUCHSCREEN_AD7879 = no;
        CONFIG_TOUCHSCREEN_AD7879_I2C = no;
        CONFIG_TOUCHSCREEN_AD7879_SPI = no;
        CONFIG_TOUCHSCREEN_ADC = no;
        CONFIG_TOUCHSCREEN_AR1021_I2C = no;
        CONFIG_TOUCHSCREEN_ATMEL_MXT = no;
        # CONFIG_TOUCHSCREEN_ATMEL_MXT_T37 is not set
        CONFIG_TOUCHSCREEN_AUO_PIXCIR = no;
        CONFIG_TOUCHSCREEN_BU21013 = no;
        CONFIG_TOUCHSCREEN_BU21029 = no;
        CONFIG_TOUCHSCREEN_CHIPONE_ICN8318 = no;
        CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 = no;
        CONFIG_TOUCHSCREEN_CY8CTMA140 = no;
        CONFIG_TOUCHSCREEN_CY8CTMG110 = no;
        CONFIG_TOUCHSCREEN_CYTTSP_CORE = no;
        CONFIG_TOUCHSCREEN_CYTTSP_I2C = no;
        CONFIG_TOUCHSCREEN_CYTTSP_SPI = no;
        CONFIG_TOUCHSCREEN_CYTTSP5 = no;
        CONFIG_TOUCHSCREEN_DYNAPRO = no;
        CONFIG_TOUCHSCREEN_HAMPSHIRE = no;
        CONFIG_TOUCHSCREEN_EETI = no;
        CONFIG_TOUCHSCREEN_EGALAX = no;
        CONFIG_TOUCHSCREEN_EGALAX_SERIAL = no;
        CONFIG_TOUCHSCREEN_EXC3000 = no;
        CONFIG_TOUCHSCREEN_FUJITSU = no;
        CONFIG_TOUCHSCREEN_GOODIX = no;
        CONFIG_TOUCHSCREEN_GOODIX_BERLIN_CORE = no;
        CONFIG_TOUCHSCREEN_GOODIX_BERLIN_I2C = no;
        CONFIG_TOUCHSCREEN_GOODIX_BERLIN_SPI = no;
        CONFIG_TOUCHSCREEN_HIDEEP = no;
        CONFIG_TOUCHSCREEN_HIMAX_HX852X = no;
        CONFIG_TOUCHSCREEN_HYCON_HY46XX = no;
        CONFIG_TOUCHSCREEN_HYNITRON_CSTXXX = no;
        CONFIG_TOUCHSCREEN_HYNITRON_CST816X = no;
        CONFIG_TOUCHSCREEN_ILI210X = no;
        CONFIG_TOUCHSCREEN_ILITEK = no;
        CONFIG_TOUCHSCREEN_S6SY761 = no;
        CONFIG_TOUCHSCREEN_GUNZE = no;
        CONFIG_TOUCHSCREEN_EKTF2127 = no;
        CONFIG_TOUCHSCREEN_ELAN = no;
        CONFIG_TOUCHSCREEN_ELO = no;
        CONFIG_TOUCHSCREEN_WACOM_W8001 = no;
        CONFIG_TOUCHSCREEN_WACOM_I2C = no;
        CONFIG_TOUCHSCREEN_MAX11801 = no;
        CONFIG_TOUCHSCREEN_MMS114 = no;
        CONFIG_TOUCHSCREEN_MELFAS_MIP4 = no;
        CONFIG_TOUCHSCREEN_MSG2638 = no;
        CONFIG_TOUCHSCREEN_MTOUCH = no;
        CONFIG_TOUCHSCREEN_NOVATEK_NVT_TS = no;
        CONFIG_TOUCHSCREEN_IMAGIS = no;
        CONFIG_TOUCHSCREEN_IMX6UL_TSC = no;
        CONFIG_TOUCHSCREEN_INEXIO = no;
        CONFIG_TOUCHSCREEN_PENMOUNT = no;
        CONFIG_TOUCHSCREEN_EDT_FT5X06 = no;
        CONFIG_TOUCHSCREEN_TOUCHRIGHT = no;
        CONFIG_TOUCHSCREEN_TOUCHWIN = no;
        CONFIG_TOUCHSCREEN_PIXCIR = no;
        CONFIG_TOUCHSCREEN_WDT87XX_I2C = no;
        CONFIG_TOUCHSCREEN_WM97XX = no;
        CONFIG_TOUCHSCREEN_WM9705 = no;
        CONFIG_TOUCHSCREEN_WM9712 = no;
        CONFIG_TOUCHSCREEN_WM9713 = no;
        CONFIG_TOUCHSCREEN_USB_COMPOSITE = no;
        CONFIG_TOUCHSCREEN_MC13783 = no;
        CONFIG_TOUCHSCREEN_USB_EGALAX = no;
        CONFIG_TOUCHSCREEN_USB_PANJIT = no;
        CONFIG_TOUCHSCREEN_USB_3M = no;
        CONFIG_TOUCHSCREEN_USB_ITM = no;
        CONFIG_TOUCHSCREEN_USB_ETURBO = no;
        CONFIG_TOUCHSCREEN_USB_GUNZE = no;
        CONFIG_TOUCHSCREEN_USB_DMC_TSC10 = no;
        CONFIG_TOUCHSCREEN_USB_IRTOUCH = no;
        CONFIG_TOUCHSCREEN_USB_IDEALTEK = no;
        CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH = no;
        CONFIG_TOUCHSCREEN_USB_GOTOP = no;
        CONFIG_TOUCHSCREEN_USB_JASTEC = no;
        CONFIG_TOUCHSCREEN_USB_ELO = no;
        CONFIG_TOUCHSCREEN_USB_E2I = no;
        CONFIG_TOUCHSCREEN_USB_ZYTRONIC = no;
        CONFIG_TOUCHSCREEN_USB_ETT_TC45USB = no;
        CONFIG_TOUCHSCREEN_USB_NEXIO = no;
        CONFIG_TOUCHSCREEN_USB_EASYTOUCH = no;
        CONFIG_TOUCHSCREEN_TOUCHIT213 = no;
        CONFIG_TOUCHSCREEN_TSC_SERIO = no;
        CONFIG_TOUCHSCREEN_TSC200X_CORE = no;
        CONFIG_TOUCHSCREEN_TSC2004 = no;
        CONFIG_TOUCHSCREEN_TSC2005 = no;
        CONFIG_TOUCHSCREEN_TSC2007 = no;
        # CONFIG_TOUCHSCREEN_TSC2007_IIO is not set
        CONFIG_TOUCHSCREEN_RM_TS = no;
        CONFIG_TOUCHSCREEN_SILEAD = no;
        CONFIG_TOUCHSCREEN_SIS_I2C = no;
        CONFIG_TOUCHSCREEN_ST1232 = no;
        CONFIG_TOUCHSCREEN_STMFTS = no;
        CONFIG_TOUCHSCREEN_STMPE = no;
        CONFIG_TOUCHSCREEN_SUR40 = no;
        CONFIG_TOUCHSCREEN_SURFACE3_SPI = no;
        CONFIG_TOUCHSCREEN_SX8654 = no;
        CONFIG_TOUCHSCREEN_TPS6507X = no;
        CONFIG_TOUCHSCREEN_ZET6223 = no;
        CONFIG_TOUCHSCREEN_ZFORCE = no;
        CONFIG_TOUCHSCREEN_COLIBRI_VF50 = no;
        CONFIG_TOUCHSCREEN_ROHM_BU21023 = no;
        CONFIG_TOUCHSCREEN_IQS5XX = no;
        CONFIG_TOUCHSCREEN_IQS7211 = no;
        CONFIG_TOUCHSCREEN_ZINITIX = no;
        CONFIG_TOUCHSCREEN_HIMAX_HX83112B = no;
        CONFIG_INPUT_MISC = no;
        CONFIG_INPUT_88PM80X_ONKEY = no;
        CONFIG_INPUT_AD714X = no;
        CONFIG_INPUT_AD714X_I2C = no;
        CONFIG_INPUT_AD714X_SPI = no;
        CONFIG_INPUT_ARIZONA_HAPTICS = no;
        CONFIG_INPUT_ATC260X_ONKEY = no;
        CONFIG_INPUT_ATMEL_CAPTOUCH = no;
        CONFIG_INPUT_AW86927 = no;
        CONFIG_INPUT_BMA150 = no;
        CONFIG_INPUT_CS40L50_VIBRA = no;
        CONFIG_INPUT_E3X0_BUTTON = no;
        CONFIG_INPUT_PCSPKR = no;
        CONFIG_INPUT_MAX7360_ROTARY = no;
        CONFIG_INPUT_MAX77650_ONKEY = no;
        CONFIG_INPUT_MAX77693_HAPTIC = no;
        CONFIG_INPUT_MC13783_PWRBUTTON = no;
        CONFIG_INPUT_MMA8450 = no;
        CONFIG_INPUT_APANEL = no;
        CONFIG_INPUT_GPIO_BEEPER = no;
        CONFIG_INPUT_GPIO_DECODER = no;
        CONFIG_INPUT_GPIO_VIBRA = no;
        CONFIG_INPUT_CPCAP_PWRBUTTON = no;
        CONFIG_INPUT_ATLAS_BTNS = no;
        CONFIG_INPUT_ATI_REMOTE2 = no;
        CONFIG_INPUT_KEYSPAN_REMOTE = no;
        CONFIG_INPUT_KXTJ9 = no;
        CONFIG_INPUT_POWERMATE = no;
        CONFIG_INPUT_YEALINK = no;
        CONFIG_INPUT_CM109 = no;
        CONFIG_INPUT_REGULATOR_HAPTIC = no;
        CONFIG_INPUT_RETU_PWRBUTTON = no;
        CONFIG_INPUT_TPS65218_PWRBUTTON = no;
        CONFIG_INPUT_TPS65219_PWRBUTTON = no;
        CONFIG_INPUT_TPS6594_PWRBUTTON = no;
        CONFIG_INPUT_AXP20X_PEK = no;
        CONFIG_INPUT_UINPUT = no;
        CONFIG_INPUT_PALMAS_PWRBUTTON = no;
        CONFIG_INPUT_PCF8574 = no;
        CONFIG_INPUT_PWM_BEEPER = no;
        CONFIG_INPUT_PWM_VIBRA = no;
        CONFIG_INPUT_RK805_PWRKEY = no;
        CONFIG_INPUT_GPIO_ROTARY_ENCODER = no;
        CONFIG_INPUT_DA7280_HAPTICS = no;
        CONFIG_INPUT_DA9063_ONKEY = no;
        CONFIG_INPUT_ADXL34X = no;
        CONFIG_INPUT_ADXL34X_I2C = no;
        CONFIG_INPUT_ADXL34X_SPI = no;
        CONFIG_INPUT_IBM_PANEL = no;
        CONFIG_INPUT_IMS_PCU = no;
        CONFIG_INPUT_IQS269A = no;
        CONFIG_INPUT_IQS626A = no;
        CONFIG_INPUT_IQS7222 = no;
        CONFIG_INPUT_CMA3000 = no;
        CONFIG_INPUT_CMA3000_I2C = no;
        CONFIG_INPUT_XEN_KBDDEV_FRONTEND = no;
        CONFIG_INPUT_IDEAPAD_SLIDEBAR = no;
        CONFIG_INPUT_DRV260X_HAPTICS = no;
        CONFIG_INPUT_DRV2665_HAPTICS = no;
        CONFIG_INPUT_DRV2667_HAPTICS = no;
        CONFIG_INPUT_QNAP_MCU = no;
        CONFIG_INPUT_RAVE_SP_PWRBUTTON = no;
        CONFIG_INPUT_RT5120_PWRKEY = no;
        CONFIG_INPUT_STPMIC1_ONKEY = no;

        CONFIG_SERIO_I8042 = no;
        CONFIG_SERIO_CT82C710 = no;
        CONFIG_SERIO_PARKBD = no;
        CONFIG_SERIO_PCIPS2 = no;
        CONFIG_SERIO_LIBPS2 = no;
        CONFIG_SERIO_ALTERA_PS2 = no;
        CONFIG_SERIO_PS2MULT = no;
        CONFIG_SERIO_ARC_PS2 = no;
        CONFIG_SERIO_APBPS2 = no;
        CONFIG_SERIO_GPIO_PS2 = no;
        CONFIG_GAMEPORT_EMU10K1 = no;
        CONFIG_GAMEPORT_FM801 = no;

        CONFIG_SERIAL_8250_CS = no;
        CONFIG_SERIAL_8250_MEN_MCB = no;
        CONFIG_SERIAL_8250_DFL = no;

        CONFIG_SERIAL_SIFIVE = no;
        CONFIG_SERIAL_XILINX_PS_UART = no;
        CONFIG_SERIAL_CONEXANT_DIGICOLOR = no;
        CONFIG_SERIAL_MEN_Z135 = no;
        CONFIG_SERIAL_LITEUART = no;

        CONFIG_SERIAL_NONSTANDARD = no;
        CONFIG_MOXA_INTELLIO = no;
        CONFIG_MOXA_SMARTIO = no;
        CONFIG_N_HDLC = no;
        CONFIG_IPWIRELESS = no;
        CONFIG_N_GSM = no;
        CONFIG_NOZOMI = no;

        CONFIG_PRINTER = no;
        # CONFIG_LP_CONSOLE is not set
        CONFIG_PPDEV = no;

        CONFIG_IPMB_DEVICE_INTERFACE = no;
        CONFIG_HW_RANDOM_CCTRNG = no;
        CONFIG_APPLICOM = no;
        CONFIG_MWAVE = no;
        CONFIG_TELCLOCK = no;
        CONFIG_XILLYBUS_CLASS = no;
        CONFIG_XILLYBUS = no;
        CONFIG_XILLYBUS_PCIE = no;
        CONFIG_XILLYBUS_OF = no;
        CONFIG_XILLYUSB = no;

        CONFIG_HSI = no;
        CONFIG_HSI_BOARDINFO = no;

        CONFIG_ZL3073X = no;
        CONFIG_SSB = no;
        CONFIG_BCMA = no;

        CONFIG_RC_CORE = no;
        # CONFIG_BPF_LIRC_MODE2 is not set
        CONFIG_LIRC = no;
        CONFIG_RC_MAP = no;
        CONFIG_RC_DECODERS = no;
        CONFIG_IR_IMON_DECODER = no;
        CONFIG_IR_JVC_DECODER = no;
        CONFIG_IR_MCE_KBD_DECODER = no;
        CONFIG_IR_NEC_DECODER = no;
        CONFIG_IR_RC5_DECODER = no;
        CONFIG_IR_RC6_DECODER = no;
        CONFIG_IR_RCMM_DECODER = no;
        CONFIG_IR_SANYO_DECODER = no;
        CONFIG_IR_SHARP_DECODER = no;
        CONFIG_IR_SONY_DECODER = no;
        CONFIG_IR_XMP_DECODER = no;
        CONFIG_RC_DEVICES = no;
        CONFIG_IR_ENE = no;
        CONFIG_IR_FINTEK = no;
        CONFIG_IR_GPIO_CIR = no;
        CONFIG_IR_GPIO_TX = no;
        CONFIG_IR_HIX5HD2 = no;
        CONFIG_IR_IGORPLUGUSB = no;
        CONFIG_IR_IGUANA = no;
        CONFIG_IR_IMON = no;
        CONFIG_IR_IMON_RAW = no;
        CONFIG_IR_ITE_CIR = no;
        CONFIG_IR_MCEUSB = no;
        CONFIG_IR_NUVOTON = no;
        CONFIG_IR_PWM_TX = no;
        CONFIG_IR_REDRAT3 = no;
        CONFIG_IR_SERIAL = no;
        # CONFIG_IR_SERIAL_TRANSMITTER is not set
        CONFIG_IR_SPI = no;
        CONFIG_IR_STREAMZAP = no;
        CONFIG_IR_TOY = no;
        CONFIG_IR_TTUSBIR = no;
        CONFIG_IR_WINBOND_CIR = no;
        CONFIG_RC_ATI_REMOTE = no;
        CONFIG_RC_LOOPBACK = no;
        CONFIG_RC_XBOX_DVD = no;

        CONFIG_MEDIA_CEC_RC = no;
        CONFIG_DVB_CORE = no;
        CONFIG_VIDEO_TUNER = no;
        CONFIG_MEDIA_CONTROLLER_DVB = no;
        CONFIG_DVB_NET = no;
        CONFIG_DVB_DYNAMIC_MINORS = no;
        CONFIG_USB_S2255 = no;
        CONFIG_VIDEO_USBTV = no;
        CONFIG_USB_VIDEO_CLASS = no;
        CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV = no;

        CONFIG_VIDEO_GO7007 = no;
        CONFIG_VIDEO_GO7007_USB = no;
        CONFIG_VIDEO_GO7007_LOADER = no;
        CONFIG_VIDEO_GO7007_USB_S2250_BOARD = no;
        CONFIG_VIDEO_HDPVR = no;
        CONFIG_VIDEO_PVRUSB2 = no;
        CONFIG_VIDEO_PVRUSB2_SYSFS = no;
        CONFIG_VIDEO_PVRUSB2_DVB = no;
        # CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
        CONFIG_VIDEO_STK1160 = no;

        CONFIG_VIDEO_AU0828 = no;
        CONFIG_VIDEO_AU0828_V4L2 = no;
        # CONFIG_VIDEO_AU0828_RC is not set
        CONFIG_VIDEO_CX231XX = no;
        CONFIG_VIDEO_CX231XX_RC = no;
        CONFIG_VIDEO_CX231XX_ALSA = no;
        CONFIG_VIDEO_CX231XX_DVB = no;

        CONFIG_DVB_AS102 = no;
        CONFIG_DVB_B2C2_FLEXCOP_USB = no;
        # CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
        CONFIG_DVB_USB_V2 = no;
        CONFIG_DVB_USB_AF9015 = no;
        CONFIG_DVB_USB_AF9035 = no;
        CONFIG_DVB_USB_ANYSEE = no;
        CONFIG_DVB_USB_AU6610 = no;
        CONFIG_DVB_USB_AZ6007 = no;
        CONFIG_DVB_USB_CE6230 = no;
        CONFIG_DVB_USB_DVBSKY = no;
        CONFIG_DVB_USB_EC168 = no;
        CONFIG_DVB_USB_GL861 = no;
        CONFIG_DVB_USB_LME2510 = no;
        CONFIG_DVB_USB_MXL111SF = no;
        CONFIG_DVB_USB_RTL28XXU = no;
        CONFIG_DVB_USB_ZD1301 = no;
        CONFIG_DVB_USB = no;
        # CONFIG_DVB_USB_DEBUG is not set
        CONFIG_DVB_USB_A800 = no;
        CONFIG_DVB_USB_AF9005 = no;
        CONFIG_DVB_USB_AF9005_REMOTE = no;
        CONFIG_DVB_USB_AZ6027 = no;
        CONFIG_DVB_USB_CINERGY_T2 = no;
        CONFIG_DVB_USB_CXUSB = no;
        # CONFIG_DVB_USB_CXUSB_ANALOG is not set
        CONFIG_DVB_USB_DIB0700 = no;
        CONFIG_DVB_USB_DIB3000MC = no;
        CONFIG_DVB_USB_DIBUSB_MB = no;
        # CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
        CONFIG_DVB_USB_DIBUSB_MC = no;
        CONFIG_DVB_USB_DIGITV = no;
        CONFIG_DVB_USB_DTT200U = no;
        CONFIG_DVB_USB_DTV5100 = no;
        CONFIG_DVB_USB_DW2102 = no;
        CONFIG_DVB_USB_GP8PSK = no;
        CONFIG_DVB_USB_M920X = no;
        CONFIG_DVB_USB_NOVA_T_USB2 = no;
        CONFIG_DVB_USB_OPERA1 = no;
        CONFIG_DVB_USB_PCTV452E = no;
        CONFIG_DVB_USB_TECHNISAT_USB2 = no;
        CONFIG_DVB_USB_TTUSB2 = no;
        CONFIG_DVB_USB_UMT_010 = no;
        CONFIG_DVB_USB_VP702X = no;
        CONFIG_DVB_USB_VP7045 = no;
        CONFIG_SMS_USB_DRV = no;
        CONFIG_DVB_TTUSB_BUDGET = no;
        CONFIG_DVB_TTUSB_DEC = no;

        CONFIG_VIDEO_EM28XX = no;
        CONFIG_VIDEO_EM28XX_V4L2 = no;
        CONFIG_VIDEO_EM28XX_ALSA = no;
        CONFIG_VIDEO_EM28XX_DVB = no;
        CONFIG_VIDEO_EM28XX_RC = no;

        CONFIG_USB_AIRSPY = no;
        CONFIG_USB_HACKRF = no;
        CONFIG_USB_MSI2500 = no;
        CONFIG_MEDIA_PCI_SUPPORT = no;

        #
        # Media capture support
        #
        CONFIG_VIDEO_MGB4 = no;
        CONFIG_VIDEO_SOLO6X10 = no;
        CONFIG_VIDEO_TW5864 = no;
        CONFIG_VIDEO_TW68 = no;
        CONFIG_VIDEO_TW686X = no;
        CONFIG_VIDEO_ZORAN = no;
        # CONFIG_VIDEO_ZORAN_DC30 is not set
        # CONFIG_VIDEO_ZORAN_ZR36060 is not set

        #
        # Media capture/analog TV support
        #
        CONFIG_VIDEO_DT3155 = no;
        CONFIG_VIDEO_IVTV = no;
        CONFIG_VIDEO_IVTV_ALSA = no;
        CONFIG_VIDEO_FB_IVTV = no;
        # CONFIG_VIDEO_FB_IVTV_FORCE_PAT is not set
        CONFIG_VIDEO_HEXIUM_GEMINI = no;
        CONFIG_VIDEO_HEXIUM_ORION = no;
        CONFIG_VIDEO_MXB = no;

        #
        # Media capture/analog/hybrid TV support
        #
        CONFIG_VIDEO_BT848 = no;
        CONFIG_DVB_BT8XX = no;
        CONFIG_VIDEO_CX18 = no;
        CONFIG_VIDEO_CX18_ALSA = no;
        CONFIG_VIDEO_CX23885 = no;
        CONFIG_MEDIA_ALTERA_CI = no;
        CONFIG_VIDEO_CX25821 = no;
        CONFIG_VIDEO_CX25821_ALSA = no;
        CONFIG_VIDEO_CX88 = no;
        CONFIG_VIDEO_CX88_ALSA = no;
        CONFIG_VIDEO_CX88_BLACKBIRD = no;
        CONFIG_VIDEO_CX88_DVB = no;
        CONFIG_VIDEO_CX88_ENABLE_VP3054 = no;
        CONFIG_VIDEO_CX88_VP3054 = no;
        CONFIG_VIDEO_CX88_MPEG = no;
        CONFIG_VIDEO_SAA7134 = no;
        CONFIG_VIDEO_SAA7134_ALSA = no;
        CONFIG_VIDEO_SAA7134_RC = no;
        CONFIG_VIDEO_SAA7134_DVB = no;
        CONFIG_VIDEO_SAA7134_GO7007 = no;
        CONFIG_VIDEO_SAA7164 = no;

        #
        # Media digital TV PCI Adapters
        #
        CONFIG_DVB_B2C2_FLEXCOP_PCI = no;
        # CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
        CONFIG_DVB_DDBRIDGE = no;
        # CONFIG_DVB_DDBRIDGE_MSIENABLE is not set
        CONFIG_DVB_DM1105 = no;
        CONFIG_MANTIS_CORE = no;
        CONFIG_DVB_MANTIS = no;
        CONFIG_DVB_HOPPER = no;
        CONFIG_DVB_NETUP_UNIDVB = no;
        CONFIG_DVB_NGENE = no;
        CONFIG_DVB_PLUTO2 = no;
        CONFIG_DVB_PT1 = no;
        CONFIG_DVB_PT3 = no;
        CONFIG_DVB_SMIPCIE = no;
        CONFIG_DVB_BUDGET_CORE = no;
        CONFIG_DVB_BUDGET = no;
        CONFIG_DVB_BUDGET_CI = no;
        CONFIG_DVB_BUDGET_AV = no;
        CONFIG_RADIO_ADAPTERS = no;
        CONFIG_RADIO_MAXIRADIO = no;
        CONFIG_RADIO_SAA7706H = no;
        CONFIG_RADIO_SHARK = no;
        CONFIG_RADIO_SHARK2 = no;
        CONFIG_RADIO_SI4713 = no;
        CONFIG_RADIO_SI476X = no;
        CONFIG_RADIO_TEA575X = no;
        CONFIG_RADIO_TEA5764 = no;
        CONFIG_RADIO_TEF6862 = no;
        CONFIG_USB_DSBR = no;
        CONFIG_USB_KEENE = no;
        CONFIG_USB_MA901 = no;
        CONFIG_USB_MR800 = no;
        CONFIG_USB_RAREMONO = no;
        CONFIG_RADIO_SI470X = no;
        CONFIG_USB_SI470X = no;
        CONFIG_I2C_SI470X = no;
        CONFIG_USB_SI4713 = no;
        CONFIG_PLATFORM_SI4713 = no;
        CONFIG_I2C_SI4713 = no;

        CONFIG_VIDEO_CADENCE_CSI2RX = no;
        CONFIG_VIDEO_CADENCE_CSI2TX = no;

        CONFIG_VIDEO_RP1_CFE = no;

        CONFIG_SMS_SDIO_DRV = no;

        CONFIG_DVB_FIREDTV = no;
        CONFIG_DVB_FIREDTV_INPUT = no;
        CONFIG_MEDIA_COMMON_OPTIONS = no;

        CONFIG_CYPRESS_FIRMWARE = no;
        CONFIG_TTPCI_EEPROM = no;

        CONFIG_VIDEO_CX2341X = no;
        CONFIG_VIDEO_TVEEPROM = no;
        CONFIG_DVB_B2C2_FLEXCOP = no;
        CONFIG_VIDEO_SAA7146 = no;
        CONFIG_VIDEO_SAA7146_VV = no;
        CONFIG_SMS_SIANO_MDTV = no;
        CONFIG_SMS_SIANO_RC = no;
        CONFIG_VIDEOBUF2_DMA_CONTIG = no;
        CONFIG_VIDEOBUF2_DVB = no;

        CONFIG_VIDEO_ADP1653 = no;
        CONFIG_VIDEO_LM3560 = no;
        CONFIG_VIDEO_LM3646 = no;

        CONFIG_VIDEO_CS3308 = no;
        CONFIG_VIDEO_CS5345 = no;
        CONFIG_VIDEO_CS53L32A = no;
        CONFIG_VIDEO_MSP3400 = no;
        CONFIG_VIDEO_SONY_BTF_MPX = no;
        CONFIG_VIDEO_TDA1997X = no;
        CONFIG_VIDEO_TDA7432 = no;
        CONFIG_VIDEO_TDA9840 = no;
        CONFIG_VIDEO_TEA6415C = no;
        CONFIG_VIDEO_TEA6420 = no;
        CONFIG_VIDEO_TLV320AIC23B = no;
        CONFIG_VIDEO_TVAUDIO = no;
        CONFIG_VIDEO_UDA1342 = no;
        CONFIG_VIDEO_VP27SMPX = no;
        CONFIG_VIDEO_WM8739 = no;
        CONFIG_VIDEO_WM8775 = no;

        CONFIG_VIDEO_SAA6588 = no;

        CONFIG_VIDEO_ADV7180 = no;
        CONFIG_VIDEO_ADV7183 = no;
        CONFIG_VIDEO_ADV748X = no;
        CONFIG_VIDEO_ADV7604 = no;
        # CONFIG_VIDEO_ADV7604_CEC is not set
        CONFIG_VIDEO_ADV7842 = no;
        # CONFIG_VIDEO_ADV7842_CEC is not set
        CONFIG_VIDEO_BT819 = no;
        CONFIG_VIDEO_BT856 = no;
        CONFIG_VIDEO_BT866 = no;
        CONFIG_VIDEO_ISL7998X = no;
        CONFIG_VIDEO_LT6911UXE = no;
        CONFIG_VIDEO_KS0127 = no;
        CONFIG_VIDEO_MAX9286 = no;
        CONFIG_VIDEO_ML86V7667 = no;
        CONFIG_VIDEO_SAA7110 = no;
        CONFIG_VIDEO_SAA711X = no;
        CONFIG_VIDEO_TC358743 = no;
        # CONFIG_VIDEO_TC358743_CEC is not set
        CONFIG_VIDEO_TC358746 = no;
        CONFIG_VIDEO_TVP514X = no;
        CONFIG_VIDEO_TVP5150 = no;
        CONFIG_VIDEO_TVP7002 = no;
        CONFIG_VIDEO_TW2804 = no;
        CONFIG_VIDEO_TW9900 = no;
        CONFIG_VIDEO_TW9903 = no;
        CONFIG_VIDEO_TW9906 = no;
        CONFIG_VIDEO_TW9910 = no;
        CONFIG_VIDEO_VPX3220 = no;

        CONFIG_VIDEO_SAA717X = no;
        CONFIG_VIDEO_CX25840 = no;

        CONFIG_VIDEO_ADV7170 = no;
        CONFIG_VIDEO_ADV7175 = no;
        CONFIG_VIDEO_ADV7343 = no;
        CONFIG_VIDEO_ADV7393 = no;
        CONFIG_VIDEO_AK881X = no;
        CONFIG_VIDEO_SAA7127 = no;
        CONFIG_VIDEO_SAA7185 = no;
        CONFIG_VIDEO_THS8200 = no;

        CONFIG_VIDEO_UPD64031A = no;
        CONFIG_VIDEO_UPD64083 = no;

        CONFIG_VIDEO_SAA6752HS = no;

        CONFIG_SDR_MAX2175 = no;

        CONFIG_VIDEO_I2C = no;
        CONFIG_VIDEO_M52790 = no;
        CONFIG_VIDEO_ST_MIPID02 = no;
        CONFIG_VIDEO_THS7303 = no;

        CONFIG_VIDEO_DS90UB913 = no;
        CONFIG_VIDEO_DS90UB953 = no;
        CONFIG_VIDEO_DS90UB960 = no;
        CONFIG_VIDEO_MAX96714 = no;
        CONFIG_VIDEO_MAX96717 = no;

        CONFIG_CXD2880_SPI_DRV = no;
        CONFIG_VIDEO_GS1662 = no;

        CONFIG_MEDIA_TUNER_E4000 = no;
        CONFIG_MEDIA_TUNER_FC0011 = no;
        CONFIG_MEDIA_TUNER_FC0012 = no;
        CONFIG_MEDIA_TUNER_FC0013 = no;
        CONFIG_MEDIA_TUNER_FC2580 = no;
        CONFIG_MEDIA_TUNER_IT913X = no;
        CONFIG_MEDIA_TUNER_M88RS6000T = no;
        CONFIG_MEDIA_TUNER_MAX2165 = no;
        CONFIG_MEDIA_TUNER_MC44S803 = no;
        CONFIG_MEDIA_TUNER_MSI001 = no;
        CONFIG_MEDIA_TUNER_MT2060 = no;
        CONFIG_MEDIA_TUNER_MT2063 = no;
        CONFIG_MEDIA_TUNER_MT20XX = no;
        CONFIG_MEDIA_TUNER_MT2131 = no;
        CONFIG_MEDIA_TUNER_MT2266 = no;
        CONFIG_MEDIA_TUNER_MXL301RF = no;
        CONFIG_MEDIA_TUNER_MXL5005S = no;
        CONFIG_MEDIA_TUNER_MXL5007T = no;
        CONFIG_MEDIA_TUNER_QM1D1B0004 = no;
        CONFIG_MEDIA_TUNER_QM1D1C0042 = no;
        CONFIG_MEDIA_TUNER_QT1010 = no;
        CONFIG_MEDIA_TUNER_R820T = no;
        CONFIG_MEDIA_TUNER_SI2157 = no;
        CONFIG_MEDIA_TUNER_SIMPLE = no;
        CONFIG_MEDIA_TUNER_TDA18212 = no;
        CONFIG_MEDIA_TUNER_TDA18218 = no;
        CONFIG_MEDIA_TUNER_TDA18250 = no;
        CONFIG_MEDIA_TUNER_TDA18271 = no;
        CONFIG_MEDIA_TUNER_TDA827X = no;
        CONFIG_MEDIA_TUNER_TDA8290 = no;
        CONFIG_MEDIA_TUNER_TDA9887 = no;
        CONFIG_MEDIA_TUNER_TEA5761 = no;
        CONFIG_MEDIA_TUNER_TEA5767 = no;
        CONFIG_MEDIA_TUNER_TUA9001 = no;
        CONFIG_MEDIA_TUNER_XC2028 = no;
        CONFIG_MEDIA_TUNER_XC4000 = no;
        CONFIG_MEDIA_TUNER_XC5000 = no;

        CONFIG_DVB_M88DS3103 = no;
        CONFIG_DVB_MXL5XX = no;
        CONFIG_DVB_STB0899 = no;
        CONFIG_DVB_STB6100 = no;
        CONFIG_DVB_STV090x = no;
        CONFIG_DVB_STV0910 = no;
        CONFIG_DVB_STV6110x = no;
        CONFIG_DVB_STV6111 = no;

        #
        # Multistandard (cable + terrestrial) frontends
        #
        CONFIG_DVB_DRXK = no;
        CONFIG_DVB_MN88472 = no;
        CONFIG_DVB_MN88473 = no;
        CONFIG_DVB_SI2165 = no;
        CONFIG_DVB_TDA18271C2DD = no;

        #
        # DVB-S (satellite) frontends
        #
        CONFIG_DVB_CX24110 = no;
        CONFIG_DVB_CX24116 = no;
        CONFIG_DVB_CX24117 = no;
        CONFIG_DVB_CX24120 = no;
        CONFIG_DVB_CX24123 = no;
        CONFIG_DVB_DS3000 = no;
        CONFIG_DVB_MB86A16 = no;
        CONFIG_DVB_MT312 = no;
        CONFIG_DVB_S5H1420 = no;
        CONFIG_DVB_SI21XX = no;
        CONFIG_DVB_STB6000 = no;
        CONFIG_DVB_STV0288 = no;
        CONFIG_DVB_STV0299 = no;
        CONFIG_DVB_STV0900 = no;
        CONFIG_DVB_STV6110 = no;
        CONFIG_DVB_TDA10071 = no;
        CONFIG_DVB_TDA10086 = no;
        CONFIG_DVB_TDA8083 = no;
        CONFIG_DVB_TDA8261 = no;
        CONFIG_DVB_TDA826X = no;
        CONFIG_DVB_TS2020 = no;
        CONFIG_DVB_TUA6100 = no;
        CONFIG_DVB_TUNER_CX24113 = no;
        CONFIG_DVB_TUNER_ITD1000 = no;
        CONFIG_DVB_VES1X93 = no;
        CONFIG_DVB_ZL10036 = no;
        CONFIG_DVB_ZL10039 = no;

        #
        # DVB-T (terrestrial) frontends
        #
        CONFIG_DVB_AF9013 = no;
        CONFIG_DVB_AS102_FE = no;
        CONFIG_DVB_CX22700 = no;
        CONFIG_DVB_CX22702 = no;
        CONFIG_DVB_CXD2820R = no;
        CONFIG_DVB_CXD2841ER = no;
        CONFIG_DVB_DIB3000MB = no;
        CONFIG_DVB_DIB3000MC = no;
        CONFIG_DVB_DIB7000M = no;
        CONFIG_DVB_DIB7000P = no;
        CONFIG_DVB_DIB9000 = no;
        CONFIG_DVB_DRXD = no;
        CONFIG_DVB_EC100 = no;
        CONFIG_DVB_GP8PSK_FE = no;
        CONFIG_DVB_L64781 = no;
        CONFIG_DVB_MT352 = no;
        CONFIG_DVB_NXT6000 = no;
        CONFIG_DVB_RTL2830 = no;
        CONFIG_DVB_RTL2832 = no;
        CONFIG_DVB_RTL2832_SDR = no;
        CONFIG_DVB_S5H1432 = no;
        CONFIG_DVB_SI2168 = no;
        CONFIG_DVB_SP887X = no;
        CONFIG_DVB_STV0367 = no;
        CONFIG_DVB_TDA10048 = no;
        CONFIG_DVB_TDA1004X = no;
        CONFIG_DVB_ZD1301_DEMOD = no;
        CONFIG_DVB_ZL10353 = no;
        CONFIG_DVB_CXD2880 = no;

        #
        # DVB-C (cable) frontends
        #
        CONFIG_DVB_STV0297 = no;
        CONFIG_DVB_TDA10021 = no;
        CONFIG_DVB_TDA10023 = no;
        CONFIG_DVB_VES1820 = no;

        #
        # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
        #
        CONFIG_DVB_AU8522 = no;
        CONFIG_DVB_AU8522_DTV = no;
        CONFIG_DVB_AU8522_V4L = no;
        CONFIG_DVB_BCM3510 = no;
        CONFIG_DVB_LG2160 = no;
        CONFIG_DVB_LGDT3305 = no;
        CONFIG_DVB_LGDT3306A = no;
        CONFIG_DVB_LGDT330X = no;
        CONFIG_DVB_MXL692 = no;
        CONFIG_DVB_NXT200X = no;
        CONFIG_DVB_OR51132 = no;
        CONFIG_DVB_OR51211 = no;
        CONFIG_DVB_S5H1409 = no;
        CONFIG_DVB_S5H1411 = no;

        #
        # ISDB-T (terrestrial) frontends
        #
        CONFIG_DVB_DIB8000 = no;
        CONFIG_DVB_MB86A20S = no;
        CONFIG_DVB_S921 = no;

        #
        # ISDB-S (satellite) & ISDB-T (terrestrial) frontends
        #
        CONFIG_DVB_MN88443X = no;
        CONFIG_DVB_TC90522 = no;

        #
        # Digital terrestrial only tuners/PLL
        #
        CONFIG_DVB_PLL = no;
        CONFIG_DVB_TUNER_DIB0070 = no;
        CONFIG_DVB_TUNER_DIB0090 = no;

        #
        # SEC control devices for DVB-S
        #
        CONFIG_DVB_A8293 = no;
        CONFIG_DVB_AF9033 = no;
        CONFIG_DVB_ASCOT2E = no;
        CONFIG_DVB_ATBM8830 = no;
        CONFIG_DVB_HELENE = no;
        CONFIG_DVB_HORUS3A = no;
        CONFIG_DVB_ISL6405 = no;
        CONFIG_DVB_ISL6421 = no;
        CONFIG_DVB_ISL6423 = no;
        CONFIG_DVB_IX2505V = no;
        CONFIG_DVB_LGS8GL5 = no;
        CONFIG_DVB_LGS8GXX = no;
        CONFIG_DVB_LNBH25 = no;
        CONFIG_DVB_LNBH29 = no;
        CONFIG_DVB_LNBP21 = no;
        CONFIG_DVB_LNBP22 = no;
        CONFIG_DVB_M88RS2000 = no;
        CONFIG_DVB_TDA665x = no;
        CONFIG_DVB_DRX39XYJ = no;

        #
        # Common Interface (EN50221) controller drivers
        #
        CONFIG_DVB_CXD2099 = no;
        CONFIG_DVB_SP2 = no;

        CONFIG_DVB_DUMMY_FE = no;

        CONFIG_SND_FIREWIRE = no;
        CONFIG_SND_FIREWIRE_LIB = no;
        CONFIG_SND_DICE = no;
        CONFIG_SND_OXFW = no;
        CONFIG_SND_ISIGHT = no;
        CONFIG_SND_FIREWORKS = no;
        CONFIG_SND_BEBOB = no;
        CONFIG_SND_FIREWIRE_DIGI00X = no;
        CONFIG_SND_FIREWIRE_TASCAM = no;
        CONFIG_SND_FIREWIRE_MOTU = no;
        CONFIG_SND_FIREFACE = no;
        CONFIG_SND_PCMCIA = no;
        CONFIG_SND_VXPOCKET = no;
        CONFIG_SND_PDAUDIOCF = no;

        CONFIG_SND_SOC_MIKROE_PROTO = no;

        CONFIG_MEMSTICK = no;
        # CONFIG_MEMSTICK_DEBUG is not set

        #
        # MemoryStick drivers
        #
        # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
        CONFIG_MSPRO_BLOCK = no;
        CONFIG_MS_BLOCK = no;

        #
        # MemoryStick Host Controller Drivers
        #
        CONFIG_MEMSTICK_TIFM_MS = no;
        CONFIG_MEMSTICK_JMICRON_38X = no;
        CONFIG_MEMSTICK_R592 = no;
        CONFIG_MEMSTICK_REALTEK_USB = no;

        CONFIG_ACCESSIBILITY = no;
        # CONFIG_A11Y_BRAILLE_CONSOLE is not set

        #
        # Speakup console speech
        #
        CONFIG_SPEAKUP = no;
        CONFIG_SPEAKUP_SYNTH_ACNTSA = no;
        CONFIG_SPEAKUP_SYNTH_APOLLO = no;
        CONFIG_SPEAKUP_SYNTH_AUDPTR = no;
        CONFIG_SPEAKUP_SYNTH_BNS = no;
        CONFIG_SPEAKUP_SYNTH_DECTLK = no;
        CONFIG_SPEAKUP_SYNTH_DECEXT = no;
        CONFIG_SPEAKUP_SYNTH_LTLK = no;
        CONFIG_SPEAKUP_SYNTH_SOFT = no;
        CONFIG_SPEAKUP_SYNTH_SPKOUT = no;
        CONFIG_SPEAKUP_SYNTH_TXPRT = no;
        CONFIG_SPEAKUP_SYNTH_DUMMY = no;
        # end of Speakup console speech
        #
        #
        CONFIG_GREYBUS = no;
        CONFIG_GREYBUS_BEAGLEPLAY = no;
        CONFIG_GREYBUS_ES2 = no;
        CONFIG_COMEDI = no;

        # CONFIG_COMEDI_MISC_DRIVERS is not set
        CONFIG_COMEDI_PCI_DRIVERS = no;
        CONFIG_COMEDI_8255_PCI = no;
        CONFIG_COMEDI_ADDI_WATCHDOG = no;
        CONFIG_COMEDI_ADDI_APCI_1032 = no;
        CONFIG_COMEDI_ADDI_APCI_1500 = no;
        CONFIG_COMEDI_ADDI_APCI_1516 = no;
        CONFIG_COMEDI_ADDI_APCI_1564 = no;
        CONFIG_COMEDI_ADDI_APCI_16XX = no;
        CONFIG_COMEDI_ADDI_APCI_2032 = no;
        CONFIG_COMEDI_ADDI_APCI_2200 = no;
        CONFIG_COMEDI_ADDI_APCI_3120 = no;
        CONFIG_COMEDI_ADDI_APCI_3501 = no;
        CONFIG_COMEDI_ADDI_APCI_3XXX = no;
        CONFIG_COMEDI_ADL_PCI6208 = no;
        CONFIG_COMEDI_ADL_PCI7250 = no;
        CONFIG_COMEDI_ADL_PCI7X3X = no;
        CONFIG_COMEDI_ADL_PCI8164 = no;
        CONFIG_COMEDI_ADL_PCI9111 = no;
        CONFIG_COMEDI_ADL_PCI9118 = no;
        CONFIG_COMEDI_ADV_PCI1710 = no;
        CONFIG_COMEDI_ADV_PCI1720 = no;
        CONFIG_COMEDI_ADV_PCI1723 = no;
        CONFIG_COMEDI_ADV_PCI1724 = no;
        CONFIG_COMEDI_ADV_PCI1760 = no;
        CONFIG_COMEDI_ADV_PCI_DIO = no;
        CONFIG_COMEDI_AMPLC_DIO200_PCI = no;
        CONFIG_COMEDI_AMPLC_PC236_PCI = no;
        CONFIG_COMEDI_AMPLC_PC263_PCI = no;
        CONFIG_COMEDI_AMPLC_PCI224 = no;
        CONFIG_COMEDI_AMPLC_PCI230 = no;
        CONFIG_COMEDI_CONTEC_PCI_DIO = no;
        CONFIG_COMEDI_DAS08_PCI = no;
        CONFIG_COMEDI_DT3000 = no;
        CONFIG_COMEDI_DYNA_PCI10XX = no;
        CONFIG_COMEDI_GSC_HPDI = no;
        CONFIG_COMEDI_MF6X4 = no;
        CONFIG_COMEDI_ICP_MULTI = no;
        CONFIG_COMEDI_DAQBOARD2000 = no;
        CONFIG_COMEDI_JR3_PCI = no;
        CONFIG_COMEDI_KE_COUNTER = no;
        CONFIG_COMEDI_CB_PCIDAS64 = no;
        CONFIG_COMEDI_CB_PCIDAS = no;
        CONFIG_COMEDI_CB_PCIDDA = no;
        CONFIG_COMEDI_CB_PCIMDAS = no;
        CONFIG_COMEDI_CB_PCIMDDA = no;
        CONFIG_COMEDI_ME4000 = no;
        CONFIG_COMEDI_ME_DAQ = no;
        CONFIG_COMEDI_NI_6527 = no;
        CONFIG_COMEDI_NI_65XX = no;
        CONFIG_COMEDI_NI_660X = no;
        CONFIG_COMEDI_NI_670X = no;
        CONFIG_COMEDI_NI_LABPC_PCI = no;
        CONFIG_COMEDI_NI_PCIDIO = no;
        CONFIG_COMEDI_NI_PCIMIO = no;
        CONFIG_COMEDI_RTD520 = no;
        CONFIG_COMEDI_S626 = no;
        CONFIG_COMEDI_MITE = no;
        CONFIG_COMEDI_NI_TIOCMD = no;
        CONFIG_COMEDI_PCMCIA_DRIVERS = no;
        CONFIG_COMEDI_CB_DAS16_CS = no;
        CONFIG_COMEDI_DAS08_CS = no;
        CONFIG_COMEDI_NI_DAQ_700_CS = no;
        CONFIG_COMEDI_NI_DAQ_DIO24_CS = no;
        CONFIG_COMEDI_NI_LABPC_CS = no;
        CONFIG_COMEDI_NI_MIO_CS = no;
        CONFIG_COMEDI_QUATECH_DAQP_CS = no;
        CONFIG_COMEDI_USB_DRIVERS = no;
        CONFIG_COMEDI_DT9812 = no;
        CONFIG_COMEDI_NI_USB6501 = no;
        CONFIG_COMEDI_USBDUX = no;
        CONFIG_COMEDI_USBDUXFAST = no;
        CONFIG_COMEDI_USBDUXSIGMA = no;
        CONFIG_COMEDI_VMK80XX = no;
        CONFIG_COMEDI_8254 = no;
        CONFIG_COMEDI_8255 = no;
        CONFIG_COMEDI_8255_SA = no;
        CONFIG_COMEDI_KCOMEDILIB = no;
        CONFIG_COMEDI_AMPLC_DIO200 = no;
        CONFIG_COMEDI_AMPLC_PC236 = no;
        CONFIG_COMEDI_DAS08 = no;
        CONFIG_COMEDI_NI_LABPC = no;
        CONFIG_COMEDI_NI_TIO = no;
        CONFIG_COMEDI_NI_ROUTING = no;
        CONFIG_COMEDI_TESTS = no;
        CONFIG_COMEDI_TESTS_EXAMPLE = no;
        CONFIG_COMEDI_TESTS_NI_ROUTES = no;
        CONFIG_STAGING = no;
        CONFIG_RTL8723BS = no;

        #
        # IIO staging drivers
        #

        #
        # Accelerometers
        #
        CONFIG_ADIS16203 = no;
        # end of Accelerometers

        #
        # Analog to digital converters
        #
        CONFIG_AD7816 = no;
        # end of Analog to digital converters

        #
        # Analog digital bi-direction converters
        #
        CONFIG_ADT7316 = no;
        CONFIG_ADT7316_SPI = no;
        CONFIG_ADT7316_I2C = no;
        # end of Analog digital bi-direction converters

        #
        # Direct Digital Synthesis
        #
        CONFIG_AD9832 = no;
        CONFIG_AD9834 = no;
        # end of Direct Digital Synthesis

        #
        # Network Analyzer, Impedance Converters
        #
        CONFIG_AD5933 = no;
        # end of Network Analyzer, Impedance Converters
        # end of IIO staging drivers

        CONFIG_FB_SM750 = no;
        CONFIG_STAGING_MEDIA = no;
        # CONFIG_INTEL_ATOMISP is not set
        CONFIG_DVB_AV7110_IR = no;
        CONFIG_DVB_AV7110 = no;
        CONFIG_DVB_AV7110_OSD = no;
        CONFIG_DVB_SP8870 = no;
        CONFIG_VIDEO_MAX96712 = no;

        #
        # StarFive media platform drivers
        #
        # CONFIG_STAGING_MEDIA_DEPRECATED is not set
        CONFIG_FB_TFT = no;
        CONFIG_FB_TFT_AGM1264K_FL = no;
        CONFIG_FB_TFT_BD663474 = no;
        CONFIG_FB_TFT_HX8340BN = no;
        CONFIG_FB_TFT_HX8347D = no;
        CONFIG_FB_TFT_HX8353D = no;
        CONFIG_FB_TFT_HX8357D = no;
        CONFIG_FB_TFT_ILI9163 = no;
        CONFIG_FB_TFT_ILI9320 = no;
        CONFIG_FB_TFT_ILI9325 = no;
        CONFIG_FB_TFT_ILI9340 = no;
        CONFIG_FB_TFT_ILI9341 = no;
        CONFIG_FB_TFT_ILI9481 = no;
        CONFIG_FB_TFT_ILI9486 = no;
        CONFIG_FB_TFT_PCD8544 = no;
        CONFIG_FB_TFT_RA8875 = no;
        CONFIG_FB_TFT_S6D02A1 = no;
        CONFIG_FB_TFT_S6D1121 = no;
        CONFIG_FB_TFT_SEPS525 = no;
        CONFIG_FB_TFT_SH1106 = no;
        CONFIG_FB_TFT_SSD1289 = no;
        CONFIG_FB_TFT_SSD1305 = no;
        CONFIG_FB_TFT_SSD1306 = no;
        CONFIG_FB_TFT_SSD1331 = no;
        CONFIG_FB_TFT_SSD1351 = no;
        CONFIG_FB_TFT_ST7735R = no;
        CONFIG_FB_TFT_ST7789V = no;
        CONFIG_FB_TFT_TINYLCD = no;
        CONFIG_FB_TFT_TLS8204 = no;
        CONFIG_FB_TFT_UC1611 = no;
        CONFIG_FB_TFT_UC1701 = no;
        CONFIG_FB_TFT_UPD161704 = no;
        CONFIG_MOST_COMPONENTS = no;
        CONFIG_MOST_NET = no;
        CONFIG_MOST_VIDEO = no;
        CONFIG_MOST_DIM2 = no;
        CONFIG_GREYBUS_AUDIO = no;
        CONFIG_GREYBUS_AUDIO_APB_CODEC = no;
        CONFIG_GREYBUS_BOOTROM = no;
        CONFIG_GREYBUS_FIRMWARE = no;
        CONFIG_GREYBUS_HID = no;
        CONFIG_GREYBUS_LIGHT = no;
        CONFIG_GREYBUS_LOG = no;
        CONFIG_GREYBUS_LOOPBACK = no;
        CONFIG_GREYBUS_POWER = no;
        CONFIG_GREYBUS_RAW = no;
        CONFIG_GREYBUS_VIBRATOR = no;
        CONFIG_GREYBUS_BRIDGED_PHY = no;
        CONFIG_GREYBUS_GPIO = no;
        CONFIG_GREYBUS_I2C = no;
        CONFIG_GREYBUS_PWM = no;
        CONFIG_GREYBUS_SDIO = no;
        CONFIG_GREYBUS_SPI = no;
        CONFIG_GREYBUS_UART = no;
        CONFIG_GREYBUS_USB = no;
        CONFIG_XIL_AXIS_FIFO = no;
        # CONFIG_VME_BUS is not set
        CONFIG_GPIB = no;
        CONFIG_GPIB_COMMON = no;
        CONFIG_GPIB_AGILENT_82350B = no;
        CONFIG_GPIB_AGILENT_82357A = no;
        CONFIG_GPIB_CEC_PCI = no;
        CONFIG_GPIB_NI_PCI_ISA = no;
        CONFIG_GPIB_CB7210 = no;
        CONFIG_GPIB_NI_USB = no;
        CONFIG_GPIB_FLUKE = no;
        CONFIG_GPIB_FMH = no;
        CONFIG_GPIB_INES = no;
        CONFIG_GPIB_PCMCIA = no;
        CONFIG_GPIB_LPVO = no;
        CONFIG_GPIB_TMS9914 = no;
        CONFIG_GPIB_NEC7210 = no;

        CONFIG_CHROME_PLATFORMS = no;
        CONFIG_CHROMEOS_ACPI = no;
        CONFIG_CHROMEOS_LAPTOP = no;
        CONFIG_CHROMEOS_PSTORE = no;
        CONFIG_CHROMEOS_TBMC = no;
        CONFIG_CHROMEOS_OF_HW_PROBER = no;
        CONFIG_CROS_EC = no;
        CONFIG_CROS_EC_I2C = no;
        CONFIG_CROS_EC_RPMSG = no;
        CONFIG_CROS_EC_ISHTP = no;
        CONFIG_CROS_EC_SPI = no;
        CONFIG_CROS_EC_UART = no;
        CONFIG_CROS_EC_LPC = no;
        CONFIG_CROS_EC_PROTO = no;
        CONFIG_CROS_KBD_LED_BACKLIGHT = no;
        CONFIG_CROS_EC_CHARDEV = no;
        CONFIG_CROS_EC_LIGHTBAR = no;
        CONFIG_CROS_EC_VBC = no;
        CONFIG_CROS_EC_DEBUGFS = no;
        CONFIG_CROS_EC_SENSORHUB = no;
        CONFIG_CROS_EC_SYSFS = no;
        CONFIG_CROS_EC_TYPEC_ALTMODES = no;
        CONFIG_CROS_EC_TYPEC = no;
        CONFIG_CROS_HPS_I2C = no;
        CONFIG_CROS_USBPD_LOGGER = no;
        CONFIG_CROS_USBPD_NOTIFY = no;
        CONFIG_CHROMEOS_PRIVACY_SCREEN = no;
        CONFIG_CROS_TYPEC_SWITCH = no;
        CONFIG_WILCO_EC = no;
        CONFIG_WILCO_EC_DEBUGFS = no;
        CONFIG_WILCO_EC_EVENTS = no;
        CONFIG_WILCO_EC_TELEMETRY = no;

        CONFIG_IDEAPAD_LAPTOP = no;
        CONFIG_LENOVO_YMC = no;
        CONFIG_MSI_LAPTOP = no;
        CONFIG_SAMSUNG_GALAXYBOOK = no;
        CONFIG_SAMSUNG_LAPTOP = no;
        CONFIG_SAMSUNG_Q10 = no;
        CONFIG_ACPI_TOSHIBA = no;

        CONFIG_LITEX = no;
        CONFIG_LITEX_SOC_CONTROLLER = no;
        # end of Enable LiteX SoC Builder specific drivers

        CONFIG_WPCM450_SOC = no;
        # CONFIG_WPCM450_SOC is not set

        #
        # Qualcomm SoC drivers
        #
        CONFIG_QCOM_PDR_HELPERS = no;
        CONFIG_QCOM_PDR_MSG = no;
        CONFIG_QCOM_PMIC_PDCHARGER_ULOG = no;
        CONFIG_QCOM_PMIC_GLINK = no;
        CONFIG_QCOM_QMI_HELPERS = no;
        CONFIG_QCOM_PBS = no;

        CONFIG_IIO = no;
        CONFIG_IIO_BUFFER = no;
        CONFIG_IIO_BUFFER_CB = no;
        CONFIG_IIO_BUFFER_DMA = no;
        CONFIG_IIO_BUFFER_DMAENGINE = no;
        CONFIG_IIO_BUFFER_HW_CONSUMER = no;
        CONFIG_IIO_KFIFO_BUF = no;
        CONFIG_IIO_TRIGGERED_BUFFER = no;
        CONFIG_IIO_CONFIGFS = no;
        CONFIG_IIO_GTS_HELPER = no;
        CONFIG_IIO_TRIGGER = no;
        CONFIG_IIO_SW_DEVICE = no;
        CONFIG_IIO_SW_TRIGGER = no;
        CONFIG_IIO_TRIGGERED_EVENT = no;
        CONFIG_IIO_BACKEND = no;

        #
        # Accelerometers
        #
        CONFIG_ADIS16201 = no;
        CONFIG_ADIS16209 = no;
        CONFIG_ADXL313 = no;
        CONFIG_ADXL313_I2C = no;
        CONFIG_ADXL313_SPI = no;
        CONFIG_ADXL355 = no;
        CONFIG_ADXL355_I2C = no;
        CONFIG_ADXL355_SPI = no;
        CONFIG_ADXL367 = no;
        CONFIG_ADXL367_SPI = no;
        CONFIG_ADXL367_I2C = no;
        CONFIG_ADXL372 = no;
        CONFIG_ADXL372_SPI = no;
        CONFIG_ADXL372_I2C = no;
        CONFIG_ADXL380 = no;
        CONFIG_ADXL380_SPI = no;
        CONFIG_ADXL380_I2C = no;
        CONFIG_BMA220 = no;
        CONFIG_BMA400 = no;
        CONFIG_BMA400_I2C = no;
        CONFIG_BMA400_SPI = no;
        CONFIG_BMC150_ACCEL = no;
        CONFIG_BMC150_ACCEL_I2C = no;
        CONFIG_BMC150_ACCEL_SPI = no;
        CONFIG_BMI088_ACCEL = no;
        CONFIG_BMI088_ACCEL_I2C = no;
        CONFIG_BMI088_ACCEL_SPI = no;
        CONFIG_DA280 = no;
        CONFIG_DA311 = no;
        CONFIG_DMARD06 = no;
        CONFIG_DMARD09 = no;
        CONFIG_DMARD10 = no;
        CONFIG_FXLS8962AF = no;
        CONFIG_FXLS8962AF_I2C = no;
        CONFIG_FXLS8962AF_SPI = no;
        CONFIG_HID_SENSOR_ACCEL_3D = no;
        CONFIG_IIO_CROS_EC_ACCEL_LEGACY = no;
        CONFIG_IIO_ST_ACCEL_3AXIS = no;
        CONFIG_IIO_ST_ACCEL_I2C_3AXIS = no;
        CONFIG_IIO_ST_ACCEL_SPI_3AXIS = no;
        CONFIG_IIO_KX022A = no;
        CONFIG_IIO_KX022A_SPI = no;
        CONFIG_IIO_KX022A_I2C = no;
        CONFIG_KXSD9 = no;
        CONFIG_KXSD9_SPI = no;
        CONFIG_KXSD9_I2C = no;
        CONFIG_KXCJK1013 = no;
        CONFIG_MC3230 = no;
        CONFIG_MMA7455 = no;
        CONFIG_MMA7455_I2C = no;
        CONFIG_MMA7455_SPI = no;
        CONFIG_MMA7660 = no;
        CONFIG_MMA8452 = no;
        CONFIG_MMA9551_CORE = no;
        CONFIG_MMA9551 = no;
        CONFIG_MMA9553 = no;
        CONFIG_MSA311 = no;
        CONFIG_MXC4005 = no;
        CONFIG_MXC6255 = no;
        CONFIG_SCA3000 = no;
        CONFIG_SCA3300 = no;
        CONFIG_STK8312 = no;
        CONFIG_STK8BA50 = no;
        # end of Accelerometers

        #
        # Analog to digital converters
        #
        CONFIG_IIO_ADC_HELPER = no;
        CONFIG_AD_SIGMA_DELTA = no;
        CONFIG_AD4000 = no;
        CONFIG_AD4030 = no;
        CONFIG_AD4080 = no;
        CONFIG_AD4130 = no;
        CONFIG_AD4170_4 = no;
        CONFIG_AD4695 = no;
        CONFIG_AD4851 = no;
        CONFIG_AD7091R = no;
        CONFIG_AD7091R5 = no;
        CONFIG_AD7091R8 = no;
        CONFIG_AD7124 = no;
        CONFIG_AD7173 = no;
        CONFIG_AD7191 = no;
        CONFIG_AD7192 = no;
        CONFIG_AD7266 = no;
        CONFIG_AD7280 = no;
        CONFIG_AD7291 = no;
        CONFIG_AD7292 = no;
        CONFIG_AD7298 = no;
        CONFIG_AD7380 = no;
        CONFIG_AD7405 = no;
        CONFIG_AD7476 = no;
        CONFIG_AD7606 = no;
        CONFIG_AD7606_IFACE_PARALLEL = no;
        CONFIG_AD7606_IFACE_SPI = no;
        CONFIG_AD7625 = no;
        CONFIG_AD7766 = no;
        CONFIG_AD7768_1 = no;
        CONFIG_AD7779 = no;
        CONFIG_AD7780 = no;
        CONFIG_AD7791 = no;
        CONFIG_AD7793 = no;
        CONFIG_AD7887 = no;
        CONFIG_AD7923 = no;
        CONFIG_AD7944 = no;
        CONFIG_AD7949 = no;
        CONFIG_AD799X = no;
        CONFIG_AD9467 = no;
        CONFIG_ADE9000 = no;
        CONFIG_AXP20X_ADC = no;
        CONFIG_AXP288_ADC = no;
        CONFIG_CC10001_ADC = no;
        CONFIG_CPCAP_ADC = no;
        CONFIG_DA9150_GPADC = no;
        CONFIG_DLN2_ADC = no;
        CONFIG_ENVELOPE_DETECTOR = no;
        CONFIG_GEHC_PMC_ADC = no;
        CONFIG_HI8435 = no;
        CONFIG_HX711 = no;
        CONFIG_INA2XX_ADC = no;
        CONFIG_INTEL_DC_TI_ADC = no;
        CONFIG_INTEL_MRFLD_ADC = no;
        CONFIG_LTC2309 = no;
        CONFIG_LTC2471 = no;
        CONFIG_LTC2485 = no;
        CONFIG_LTC2496 = no;
        CONFIG_LTC2497 = no;
        CONFIG_MAX1027 = no;
        CONFIG_MAX11100 = no;
        CONFIG_MAX1118 = no;
        CONFIG_MAX11205 = no;
        CONFIG_MAX11410 = no;
        CONFIG_MAX1241 = no;
        CONFIG_MAX1363 = no;
        CONFIG_MAX34408 = no;
        CONFIG_MAX77541_ADC = no;
        CONFIG_MAX9611 = no;
        CONFIG_MCP320X = no;
        CONFIG_MCP3422 = no;
        CONFIG_MCP3564 = no;
        CONFIG_MCP3911 = no;
        CONFIG_MEDIATEK_MT6359_AUXADC = no;
        CONFIG_MEDIATEK_MT6360_ADC = no;
        CONFIG_MEDIATEK_MT6370_ADC = no;
        CONFIG_MEN_Z188_ADC = no;
        CONFIG_MP2629_ADC = no;
        CONFIG_NAU7802 = no;
        CONFIG_NCT7201 = no;
        CONFIG_PAC1921 = no;
        CONFIG_PAC1934 = no;
        CONFIG_PALMAS_GPADC = no;
        CONFIG_QCOM_VADC_COMMON = no;
        CONFIG_QCOM_SPMI_IADC = no;
        CONFIG_QCOM_SPMI_VADC = no;
        CONFIG_QCOM_SPMI_ADC5 = no;
        CONFIG_RN5T618_ADC = no;
        CONFIG_ROHM_BD79112 = no;
        CONFIG_ROHM_BD79124 = no;
        CONFIG_RICHTEK_RTQ6056 = no;
        CONFIG_SD_ADC_MODULATOR = no;
        CONFIG_STMPE_ADC = no;
        CONFIG_TI_ADC081C = no;
        CONFIG_TI_ADC0832 = no;
        CONFIG_TI_ADC084S021 = no;
        CONFIG_TI_ADC108S102 = no;
        CONFIG_TI_ADC12138 = no;
        CONFIG_TI_ADC128S052 = no;
        CONFIG_TI_ADC161S626 = no;
        CONFIG_TI_ADS1015 = no;
        CONFIG_TI_ADS1100 = no;
        CONFIG_TI_ADS1119 = no;
        CONFIG_TI_ADS124S08 = no;
        CONFIG_TI_ADS1298 = no;
        CONFIG_TI_ADS131E08 = no;
        CONFIG_TI_ADS7138 = no;
        CONFIG_TI_ADS7924 = no;
        CONFIG_TI_ADS7950 = no;
        CONFIG_TI_ADS8344 = no;
        CONFIG_TI_ADS8688 = no;
        CONFIG_TI_LMP92064 = no;
        CONFIG_TI_TLC4541 = no;
        CONFIG_TI_TSC2046 = no;
        CONFIG_VF610_ADC = no;
        CONFIG_VIPERBOARD_ADC = no;
        CONFIG_XILINX_XADC = no;
        # end of Analog to digital converters

        #
        # Analog to digital and digital to analog converters
        #
        CONFIG_AD74115 = no;
        CONFIG_AD74413R = no;
        # end of Analog to digital and digital to analog converters

        #
        # Analog Front Ends
        #
        CONFIG_IIO_RESCALE = no;
        # end of Analog Front Ends

        #
        # Amplifiers
        #
        CONFIG_AD8366 = no;
        CONFIG_ADA4250 = no;
        CONFIG_HMC425 = no;
        # end of Amplifiers

        #
        # Capacitance to digital converters
        #
        CONFIG_AD7150 = no;
        CONFIG_AD7746 = no;
        # end of Capacitance to digital converters

        #
        # Chemical Sensors
        #
        CONFIG_AOSONG_AGS02MA = no;
        CONFIG_ATLAS_PH_SENSOR = no;
        CONFIG_ATLAS_EZO_SENSOR = no;
        CONFIG_BME680 = no;
        CONFIG_BME680_I2C = no;
        CONFIG_BME680_SPI = no;
        CONFIG_CCS811 = no;
        CONFIG_ENS160 = no;
        CONFIG_ENS160_I2C = no;
        CONFIG_ENS160_SPI = no;
        CONFIG_IAQCORE = no;
        CONFIG_MHZ19B = no;
        CONFIG_PMS7003 = no;
        CONFIG_SCD30_CORE = no;
        CONFIG_SCD30_I2C = no;
        CONFIG_SCD30_SERIAL = no;
        CONFIG_SCD4X = no;
        CONFIG_SEN0322 = no;
        CONFIG_SENSIRION_SGP30 = no;
        CONFIG_SENSIRION_SGP40 = no;
        CONFIG_SPS30 = no;
        CONFIG_SPS30_I2C = no;
        CONFIG_SPS30_SERIAL = no;
        CONFIG_SENSEAIR_SUNRISE_CO2 = no;
        CONFIG_VZ89X = no;
        # end of Chemical Sensors

        CONFIG_IIO_CROS_EC_SENSORS_CORE = no;
        CONFIG_IIO_CROS_EC_SENSORS = no;
        CONFIG_IIO_CROS_EC_SENSORS_LID_ANGLE = no;
        CONFIG_IIO_CROS_EC_ACTIVITY = no;

        #
        # Hid Sensor IIO Common
        #
        CONFIG_HID_SENSOR_IIO_COMMON = no;
        CONFIG_HID_SENSOR_IIO_TRIGGER = no;
        # end of Hid Sensor IIO Common

        CONFIG_IIO_INV_SENSORS_TIMESTAMP = no;
        CONFIG_IIO_MS_SENSORS_I2C = no;

        #
        # IIO SCMI Sensors
        #
        # end of IIO SCMI Sensors

        #
        # SSP Sensor Common
        #
        CONFIG_IIO_SSP_SENSORS_COMMONS = no;
        CONFIG_IIO_SSP_SENSORHUB = no;
        # end of SSP Sensor Common

        CONFIG_IIO_ST_SENSORS_I2C = no;
        CONFIG_IIO_ST_SENSORS_SPI = no;
        CONFIG_IIO_ST_SENSORS_CORE = no;

        #
        # Digital to analog converters
        #
        CONFIG_AD3530R = no;
        CONFIG_AD3552R_HS = no;
        CONFIG_AD3552R_LIB = no;
        CONFIG_AD3552R = no;
        CONFIG_AD5064 = no;
        CONFIG_AD5360 = no;
        CONFIG_AD5380 = no;
        CONFIG_AD5421 = no;
        CONFIG_AD5446 = no;
        CONFIG_AD5449 = no;
        CONFIG_AD5592R_BASE = no;
        CONFIG_AD5592R = no;
        CONFIG_AD5593R = no;
        CONFIG_AD5504 = no;
        CONFIG_AD5624R_SPI = no;
        CONFIG_AD9739A = no;
        CONFIG_LTC2688 = no;
        CONFIG_AD5686 = no;
        CONFIG_AD5686_SPI = no;
        CONFIG_AD5696_I2C = no;
        CONFIG_AD5755 = no;
        CONFIG_AD5758 = no;
        CONFIG_AD5761 = no;
        CONFIG_AD5764 = no;
        CONFIG_AD5766 = no;
        CONFIG_AD5770R = no;
        CONFIG_AD5791 = no;
        CONFIG_AD7293 = no;
        CONFIG_AD7303 = no;
        CONFIG_AD8460 = no;
        CONFIG_AD8801 = no;
        CONFIG_BD79703 = no;
        CONFIG_DPOT_DAC = no;
        CONFIG_DS4424 = no;
        CONFIG_LTC1660 = no;
        CONFIG_LTC2632 = no;
        CONFIG_LTC2664 = no;
        CONFIG_M62332 = no;
        CONFIG_MAX517 = no;
        CONFIG_MAX5522 = no;
        CONFIG_MAX5821 = no;
        CONFIG_MCP4725 = no;
        CONFIG_MCP4728 = no;
        CONFIG_MCP4821 = no;
        CONFIG_MCP4922 = no;
        CONFIG_TI_DAC082S085 = no;
        CONFIG_TI_DAC5571 = no;
        CONFIG_TI_DAC7311 = no;
        CONFIG_TI_DAC7612 = no;
        CONFIG_VF610_DAC = no;
        # end of Digital to analog converters

        #
        # IIO dummy driver
        #
        CONFIG_IIO_SIMPLE_DUMMY = no;
        # CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
        # CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
        # end of IIO dummy driver

        #
        # Filters
        #
        CONFIG_ADMV8818 = no;
        # end of Filters

        #
        # Frequency Synthesizers DDS/PLL
        #

        #
        # Clock Generator/Distribution
        #
        CONFIG_AD9523 = no;
        # end of Clock Generator/Distribution

        #
        # Phase-Locked Loop (PLL) frequency synthesizers
        #
        CONFIG_ADF4350 = no;
        CONFIG_ADF4371 = no;
        CONFIG_ADF4377 = no;
        CONFIG_ADMFM2000 = no;
        CONFIG_ADMV1013 = no;
        CONFIG_ADMV1014 = no;
        CONFIG_ADMV4420 = no;
        CONFIG_ADRF6780 = no;
        # end of Phase-Locked Loop (PLL) frequency synthesizers
        # end of Frequency Synthesizers DDS/PLL

        #
        # Digital gyroscope sensors
        #
        CONFIG_ADIS16080 = no;
        CONFIG_ADIS16130 = no;
        CONFIG_ADIS16136 = no;
        CONFIG_ADIS16260 = no;
        CONFIG_ADXRS290 = no;
        CONFIG_ADXRS450 = no;
        CONFIG_BMG160 = no;
        CONFIG_BMG160_I2C = no;
        CONFIG_BMG160_SPI = no;
        CONFIG_FXAS21002C = no;
        CONFIG_FXAS21002C_I2C = no;
        CONFIG_FXAS21002C_SPI = no;
        CONFIG_HID_SENSOR_GYRO_3D = no;
        CONFIG_MPU3050 = no;
        CONFIG_MPU3050_I2C = no;
        CONFIG_IIO_ST_GYRO_3AXIS = no;
        CONFIG_IIO_ST_GYRO_I2C_3AXIS = no;
        CONFIG_IIO_ST_GYRO_SPI_3AXIS = no;
        CONFIG_ITG3200 = no;
        # end of Digital gyroscope sensors

        #
        # Health Sensors
        #

        #
        # Heart Rate Monitors
        #
        CONFIG_AFE4403 = no;
        CONFIG_AFE4404 = no;
        CONFIG_MAX30100 = no;
        CONFIG_MAX30102 = no;
        # end of Heart Rate Monitors
        # end of Health Sensors

        #
        # Humidity sensors
        #
        CONFIG_AM2315 = no;
        CONFIG_DHT11 = no;
        CONFIG_ENS210 = no;
        CONFIG_HDC100X = no;
        CONFIG_HDC2010 = no;
        CONFIG_HDC3020 = no;
        CONFIG_HID_SENSOR_HUMIDITY = no;
        CONFIG_HTS221 = no;
        CONFIG_HTS221_I2C = no;
        CONFIG_HTS221_SPI = no;
        CONFIG_HTU21 = no;
        CONFIG_SI7005 = no;
        CONFIG_SI7020 = no;
        # end of Humidity sensors

        #
        # Inertial measurement units
        #
        CONFIG_ADIS16400 = no;
        CONFIG_ADIS16460 = no;
        CONFIG_ADIS16475 = no;
        CONFIG_ADIS16480 = no;
        CONFIG_ADIS16550 = no;
        CONFIG_BMI160 = no;
        CONFIG_BMI160_I2C = no;
        CONFIG_BMI160_SPI = no;
        CONFIG_BMI270 = no;
        CONFIG_BMI270_I2C = no;
        CONFIG_BMI270_SPI = no;
        CONFIG_BMI323 = no;
        CONFIG_BMI323_I2C = no;
        CONFIG_BMI323_SPI = no;
        CONFIG_BOSCH_BNO055 = no;
        CONFIG_BOSCH_BNO055_SERIAL = no;
        CONFIG_BOSCH_BNO055_I2C = no;
        CONFIG_FXOS8700 = no;
        CONFIG_FXOS8700_I2C = no;
        CONFIG_FXOS8700_SPI = no;
        CONFIG_KMX61 = no;
        CONFIG_INV_ICM42600 = no;
        CONFIG_INV_ICM42600_I2C = no;
        CONFIG_INV_ICM42600_SPI = no;
        CONFIG_INV_MPU6050_IIO = no;
        CONFIG_INV_MPU6050_I2C = no;
        CONFIG_INV_MPU6050_SPI = no;
        CONFIG_SMI240 = no;
        CONFIG_IIO_ST_LSM6DSX = no;
        CONFIG_IIO_ST_LSM6DSX_I2C = no;
        CONFIG_IIO_ST_LSM6DSX_SPI = no;
        CONFIG_IIO_ST_LSM6DSX_I3C = no;
        CONFIG_IIO_ST_LSM9DS0 = no;
        CONFIG_IIO_ST_LSM9DS0_I2C = no;
        CONFIG_IIO_ST_LSM9DS0_SPI = no;
        # end of Inertial measurement units

        CONFIG_IIO_ADIS_LIB = no;
        CONFIG_IIO_ADIS_LIB_BUFFER = no;

        #
        # Light sensors
        #
        CONFIG_ACPI_ALS = no;
        CONFIG_ADJD_S311 = no;
        CONFIG_ADUX1020 = no;
        CONFIG_AL3000A = no;
        CONFIG_AL3010 = no;
        CONFIG_AL3320A = no;
        CONFIG_APDS9160 = no;
        CONFIG_APDS9300 = no;
        CONFIG_APDS9306 = no;
        CONFIG_AS73211 = no;
        CONFIG_BH1745 = no;
        CONFIG_BH1750 = no;
        CONFIG_BH1780 = no;
        CONFIG_CM32181 = no;
        CONFIG_CM3232 = no;
        CONFIG_CM3323 = no;
        CONFIG_CM3605 = no;
        CONFIG_CM36651 = no;
        CONFIG_IIO_CROS_EC_LIGHT_PROX = no;
        CONFIG_GP2AP002 = no;
        CONFIG_GP2AP020A00F = no;
        CONFIG_IQS621_ALS = no;
        CONFIG_SENSORS_ISL29018 = no;
        CONFIG_SENSORS_ISL29028 = no;
        CONFIG_ISL29125 = no;
        CONFIG_ISL76682 = no;
        CONFIG_HID_SENSOR_ALS = no;
        CONFIG_HID_SENSOR_PROX = no;
        CONFIG_JSA1212 = no;
        CONFIG_ROHM_BU27034 = no;
        CONFIG_RPR0521 = no;
        CONFIG_SENSORS_LM3533 = no;
        CONFIG_LTR390 = no;
        CONFIG_LTR501 = no;
        CONFIG_LTRF216A = no;
        CONFIG_LV0104CS = no;
        CONFIG_MAX44000 = no;
        CONFIG_MAX44009 = no;
        CONFIG_NOA1305 = no;
        CONFIG_OPT3001 = no;
        CONFIG_OPT4001 = no;
        CONFIG_OPT4060 = no;
        CONFIG_PA12203001 = no;
        CONFIG_SI1133 = no;
        CONFIG_SI1145 = no;
        CONFIG_STK3310 = no;
        CONFIG_ST_UVIS25 = no;
        CONFIG_ST_UVIS25_I2C = no;
        CONFIG_ST_UVIS25_SPI = no;
        CONFIG_TCS3414 = no;
        CONFIG_TCS3472 = no;
        CONFIG_SENSORS_TSL2563 = no;
        CONFIG_TSL2583 = no;
        CONFIG_TSL2591 = no;
        CONFIG_TSL2772 = no;
        CONFIG_TSL4531 = no;
        CONFIG_US5182D = no;
        CONFIG_VCNL4000 = no;
        CONFIG_VCNL4035 = no;
        CONFIG_VEML3235 = no;
        CONFIG_VEML6030 = no;
        CONFIG_VEML6040 = no;
        CONFIG_VEML6046X00 = no;
        CONFIG_VEML6070 = no;
        CONFIG_VEML6075 = no;
        CONFIG_VL6180 = no;
        CONFIG_ZOPT2201 = no;
        # end of Light sensors

        #
        # Magnetometer sensors
        #
        CONFIG_AF8133J = no;
        CONFIG_AK8974 = no;
        CONFIG_AK8975 = no;
        CONFIG_AK09911 = no;
        CONFIG_ALS31300 = no;
        CONFIG_BMC150_MAGN = no;
        CONFIG_BMC150_MAGN_I2C = no;
        CONFIG_BMC150_MAGN_SPI = no;
        CONFIG_MAG3110 = no;
        CONFIG_HID_SENSOR_MAGNETOMETER_3D = no;
        CONFIG_MMC35240 = no;
        CONFIG_IIO_ST_MAGN_3AXIS = no;
        CONFIG_IIO_ST_MAGN_I2C_3AXIS = no;
        CONFIG_IIO_ST_MAGN_SPI_3AXIS = no;
        CONFIG_INFINEON_TLV493D = no;
        CONFIG_SENSORS_HMC5843 = no;
        CONFIG_SENSORS_HMC5843_I2C = no;
        CONFIG_SENSORS_HMC5843_SPI = no;
        CONFIG_SENSORS_RM3100 = no;
        CONFIG_SENSORS_RM3100_I2C = no;
        CONFIG_SENSORS_RM3100_SPI = no;
        CONFIG_SI7210 = no;
        CONFIG_TI_TMAG5273 = no;
        CONFIG_YAMAHA_YAS530 = no;
        # end of Magnetometer sensors

        #
        # Multiplexers
        #
        CONFIG_IIO_MUX = no;
        # end of Multiplexers

        #
        # Inclinometer sensors
        #
        CONFIG_HID_SENSOR_INCLINOMETER_3D = no;
        CONFIG_HID_SENSOR_DEVICE_ROTATION = no;
        # end of Inclinometer sensors

        #
        # Triggers - standalone
        #
        CONFIG_IIO_HRTIMER_TRIGGER = no;
        CONFIG_IIO_INTERRUPT_TRIGGER = no;
        CONFIG_IIO_TIGHTLOOP_TRIGGER = no;
        CONFIG_IIO_SYSFS_TRIGGER = no;
        # end of Triggers - standalone

        #
        # Linear and angular position sensors
        #
        CONFIG_IQS624_POS = no;
        CONFIG_HID_SENSOR_CUSTOM_INTEL_HINGE = no;
        # end of Linear and angular position sensors

        #
        # Digital potentiometers
        #
        CONFIG_AD5110 = no;
        CONFIG_AD5272 = no;
        CONFIG_DS1803 = no;
        CONFIG_MAX5432 = no;
        CONFIG_MAX5481 = no;
        CONFIG_MAX5487 = no;
        CONFIG_MCP4018 = no;
        CONFIG_MCP4131 = no;
        CONFIG_MCP4531 = no;
        CONFIG_MCP41010 = no;
        CONFIG_TPL0102 = no;
        CONFIG_X9250 = no;
        # end of Digital potentiometers

        #
        # Digital potentiostats
        #
        CONFIG_LMP91000 = no;
        # end of Digital potentiostats

        #
        # Pressure sensors
        #
        CONFIG_ABP060MG = no;
        CONFIG_ROHM_BM1390 = no;
        CONFIG_BMP280 = no;
        CONFIG_BMP280_I2C = no;
        CONFIG_BMP280_SPI = no;
        CONFIG_IIO_CROS_EC_BARO = no;
        CONFIG_DLHL60D = no;
        CONFIG_DPS310 = no;
        CONFIG_HID_SENSOR_PRESS = no;
        CONFIG_HP03 = no;
        CONFIG_HSC030PA = no;
        CONFIG_HSC030PA_I2C = no;
        CONFIG_HSC030PA_SPI = no;
        CONFIG_ICP10100 = no;
        CONFIG_MPL115 = no;
        CONFIG_MPL115_I2C = no;
        CONFIG_MPL115_SPI = no;
        CONFIG_MPL3115 = no;
        CONFIG_MPRLS0025PA = no;
        CONFIG_MPRLS0025PA_I2C = no;
        CONFIG_MPRLS0025PA_SPI = no;
        CONFIG_MS5611 = no;
        CONFIG_MS5611_I2C = no;
        CONFIG_MS5611_SPI = no;
        CONFIG_MS5637 = no;
        CONFIG_SDP500 = no;
        CONFIG_IIO_ST_PRESS = no;
        CONFIG_IIO_ST_PRESS_I2C = no;
        CONFIG_IIO_ST_PRESS_SPI = no;
        CONFIG_T5403 = no;
        CONFIG_HP206C = no;
        CONFIG_ZPA2326 = no;
        CONFIG_ZPA2326_I2C = no;
        CONFIG_ZPA2326_SPI = no;
        # end of Pressure sensors

        #
        # Lightning sensors
        #
        CONFIG_AS3935 = no;
        # end of Lightning sensors

        #
        # Proximity and distance sensors
        #
        CONFIG_CROS_EC_MKBP_PROXIMITY = no;
        CONFIG_D3323AA = no;
        CONFIG_HX9023S = no;
        CONFIG_IRSD200 = no;
        CONFIG_ISL29501 = no;
        CONFIG_LIDAR_LITE_V2 = no;
        CONFIG_MB1232 = no;
        CONFIG_PING = no;
        CONFIG_RFD77402 = no;
        CONFIG_SRF04 = no;
        CONFIG_SX_COMMON = no;
        CONFIG_SX9310 = no;
        CONFIG_SX9324 = no;
        CONFIG_SX9360 = no;
        CONFIG_SX9500 = no;
        CONFIG_SRF08 = no;
        CONFIG_VCNL3020 = no;
        CONFIG_VL53L0X_I2C = no;
        CONFIG_AW96103 = no;
        # end of Proximity and distance sensors

        #
        # Resolver to digital converters
        #
        CONFIG_AD2S90 = no;
        CONFIG_AD2S1200 = no;
        CONFIG_AD2S1210 = no;
        # end of Resolver to digital converters

        #
        # Temperature sensors
        #
        CONFIG_IQS620AT_TEMP = no;
        CONFIG_LTC2983 = no;
        CONFIG_MAXIM_THERMOCOUPLE = no;
        CONFIG_HID_SENSOR_TEMP = no;
        CONFIG_MLX90614 = no;
        CONFIG_MLX90632 = no;
        CONFIG_MLX90635 = no;
        CONFIG_TMP006 = no;
        CONFIG_TMP007 = no;
        CONFIG_TMP117 = no;
        CONFIG_TSYS01 = no;
        CONFIG_TSYS02D = no;
        CONFIG_MAX30208 = no;
        CONFIG_MAX31856 = no;
        CONFIG_MAX31865 = no;
        CONFIG_MCP9600 = no;
        # end of Temperature sensors

        CONFIG_NTB = no;
        # CONFIG_NTB_MSI is not set
        CONFIG_NTB_AMD = no;
        CONFIG_NTB_IDT = no;
        CONFIG_NTB_INTEL = no;
        CONFIG_NTB_EPF = no;
        CONFIG_NTB_SWITCHTEC = no;
        CONFIG_NTB_PINGPONG = no;
        CONFIG_NTB_TOOL = no;
        CONFIG_NTB_PERF = no;
        CONFIG_NTB_TRANSPORT = no;

        CONFIG_FPGA = no;
        CONFIG_ALTERA_PR_IP_CORE = no;
        CONFIG_ALTERA_PR_IP_CORE_PLAT = no;
        CONFIG_FPGA_MGR_ALTERA_PS_SPI = no;
        CONFIG_FPGA_MGR_ALTERA_CVP = no;
        CONFIG_FPGA_MGR_XILINX_CORE = no;
        CONFIG_FPGA_MGR_XILINX_SELECTMAP = no;
        CONFIG_FPGA_MGR_XILINX_SPI = no;
        CONFIG_FPGA_MGR_ICE40_SPI = no;
        CONFIG_FPGA_MGR_MACHXO2_SPI = no;
        CONFIG_FPGA_BRIDGE = no;
        CONFIG_ALTERA_FREEZE_BRIDGE = no;
        CONFIG_XILINX_PR_DECOUPLER = no;
        CONFIG_FPGA_REGION = no;
        CONFIG_OF_FPGA_REGION = no;
        CONFIG_FPGA_DFL = no;
        CONFIG_FPGA_DFL_FME = no;
        CONFIG_FPGA_DFL_FME_MGR = no;
        CONFIG_FPGA_DFL_FME_BRIDGE = no;
        CONFIG_FPGA_DFL_FME_REGION = no;
        CONFIG_FPGA_DFL_AFU = no;
        CONFIG_FPGA_DFL_NIOS_INTEL_PAC_N3000 = no;
        CONFIG_FPGA_DFL_PCI = no;
        CONFIG_FPGA_M10_BMC_SEC_UPDATE = no;
        CONFIG_FPGA_MGR_MICROCHIP_SPI = no;
        CONFIG_FPGA_MGR_LATTICE_SYSCONFIG = no;
        CONFIG_FPGA_MGR_LATTICE_SYSCONFIG_SPI = no;
        CONFIG_FSI = no;
        # CONFIG_FSI_NEW_DEV_NODE is not set
        CONFIG_FSI_MASTER_GPIO = no;
        CONFIG_FSI_MASTER_HUB = no;
        CONFIG_FSI_MASTER_ASPEED = no;
        CONFIG_FSI_MASTER_I2CR = no;
        CONFIG_FSI_SCOM = no;
        CONFIG_FSI_SBEFIFO = no;
        CONFIG_FSI_OCC = no;
        CONFIG_I2CR_SCOM = no;

        CONFIG_MOST = no;
        CONFIG_MOST_USB_HDM = no;
        CONFIG_MOST_CDEV = no;
        CONFIG_MOST_SND = no;
        CONFIG_PECI = no;
        CONFIG_PECI_CPU = no;
        CONFIG_SIOX = no;
        CONFIG_SIOX_BUS_GPIO = no;
        CONFIG_SLIMBUS = no;
        CONFIG_MUX_ADG792A = no;
        CONFIG_MUX_ADGS1408 = no;
        CONFIG_MUX_GPIO = no;
        CONFIG_MUX_MMIO = no;
      };
    }
  ];
}
