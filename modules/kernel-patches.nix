{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    lists
    mkIf
    mkForce
    ;

  patchSet =
    with types;
    submodule {
      options.name = mkOption {
        type = str;
        description = "Name of the patchset to apply";
      };
      options.overrides = mkOption {
        type = attrs;
        description = "Structured Attrs Kernel config to override in the patchset";
      };
    };

  definePatch =
    setName: defaultPatch:
    (mkIf
      ((lists.findSingle (x: x.name == setName) { } { } config.boot.kernel.buildConfig.patchSets) != { })
      ({
        name = setName;
        patch = null;
        structuredExtraConfig = lib.mergeAttrsList [
          defaultPatch
          (lists.findSingle (x: x.name == setName) { } { } config.boot.kernel.buildConfig.patchSets).overrides
        ];
      })
    );
in
{
  options.boot.kernel.buildConfig = {
    patchSets = lib.mkOption {
      type = lib.types.listOf patchSet;
      description = "Patches to the Kernel Config to apply";
    };
  };

  config = {
    boot.kernelPatches = with lib.kernel; [
      (definePatch "example" { })
      (definePatch "rm-unused-fs" {
        # Filesystems
        EROFS_FS = no; # containers use this?
        HFS = no; # Probably might encounter this
        HFSPLUS_FS = no;
        # PSTORE = module; # Set upstream
        SQUASHFS = module; # Generally useful
        JFS_FS = no;
        XFS_FS = no;
        GFS2_FS = no;
        NILFS2_FS = no;
        F2FS_FS = mkForce no;
        ORANGEFS_FS = no;
        ADFS_FS = no;
        AFFS_FS = no;
        BEFS_FS = no;
        BFS_FS = no;
        EFS_FS = no;
        CRAMFS = no;
        VXFS_FS = no;
        MINIX_FS = no;
        OMFS_FS = no;
        HPFS_FS = no;
        QNX4_FS = no;
        QNX6_FS = no;
        ROMFS_FS = no;
        UFS_FS = no;
        CEPH_FS = no;
        CODA_FS = no;
        AFS_FS = no;
        "9P_FS" = no;
        ROOT_NFS = no;
      })
      (definePatch "rm-x86-platform-drivers" {
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
      })
      (definePatch "rm-unused-driver-categories" {

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
      })
      (definePatch "remove-unused-individual-drivers" {
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
      })
      (definePatch "rm-net-dsa-drivers" {
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

      })
      (definePatch "rm-net-ethernet-drivers" {
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
      })
      (definePatch "rm-net-wlan-drivers" {
        WLAN_VENDOR_ADMTEK = no;
        WLAN_VENDOR_ATH = no;
        WLAN_VENDOR_ATMEL = no;
        WLAN_VENDOR_BROADCOM = no;
        WLAN_VENDOR_INTERSIL = no;
        WLAN_VENDOR_INTEL = no;
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
        IWL4965 = no;
        IWL3945 = no;
      })
      (definePatch "rm-parallel-ata" {
        # Parallel ATA
        # PATA_TIMINGS = no; # Set Incorrectly
        PATA_ACPI = no;
        PATA_LEGACY = no;
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
        # PATA_SIS = no; # Set Incorrectly
        PATA_TOSHIBA = no;
        PATA_TRIFLEX = no;
        PATA_VIA = no;
        PATA_WINBOND = no;
        PATA_CMD640_PCI = no;
        PATA_MPIIX = no;
        PATA_NS87410 = no;
        PATA_OPTI = no;
        PATA_RZ1000 = no;
        SBP_TARGET = no;
      })
      (definePatch "example" { })
      (definePatch "example" { })
      (definePatch "example" { })
      (definePatch "example" { })
      (definePatch "Remove Media Tuners" {
        # TV tuners and things like what linux supported all this?
        RC_CORE = mkForce no;
        VIDEO_TUNER = no;
        MEDIA_CONTROLLER_DVB = no;
        VIDEO_USBTV = no;
        RADIO_ADAPTERS = no;
        MEDIA_ANALOG_TV_SUPPORT = mkForce no;
        MEDIA_CEC_SUPPORT = mkForce no;
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
        DVB_M88DS3103 = no;
        DVB_MXL5XX = no;
        DVB_STB0899 = no;
        DVB_STB6100 = no;
        DVB_STV090x = no;
        DVB_STV0910 = no;
        DVB_STV6110x = no;
        DVB_STV6111 = no;
        DVB_DRXK = no;
        DVB_MN88472 = no;
        DVB_MN88473 = no;
        DVB_SI2165 = no;
        DVB_TDA18271C2DD = no;
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
        DVB_STV0297 = no;
        DVB_TDA10021 = no;
        DVB_TDA10023 = no;
        DVB_VES1820 = no;
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
        DVB_DIB8000 = no;
        DVB_MB86A20S = no;
        DVB_S921 = no;
        DVB_MN88443X = no;
        DVB_TC90522 = no;
        DVB_PLL = no;
        DVB_TUNER_DIB0070 = no;
        DVB_TUNER_DIB0090 = no;
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
        DVB_CXD2099 = no;
        DVB_SP2 = no;
        DVB_DUMMY_FE = no;
        CONFIG_VIDEO_GO7007 = no;
        CONFIG_VIDEO_HDPVR = no;
        CONFIG_VIDEO_PVRUSB2 = no;
        CONFIG_VIDEO_STK1160 = no;
        CONFIG_VIDEO_AU0828 = no;
        CONFIG_VIDEO_CX231XX = no;
      })
    ];
  };
}
