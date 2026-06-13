{
  lib,
  ...
}:
{
  ############################################
  # Hardware Configuration
  ############################################
  boot.kernelModules = [ ];
  boot.blacklistedKernelModules = [
    "dw_hdmi"
    "bluetooth"
    "btusb"
  ];
  boot.kernelParams = [
    "coherent_pool=1M"
    "8250.nr_uarts=1"
    "cgroup_disable=memory"
    "numa_policy=interleave"
    "nvme.max_host_mem_size_mb=0"
    "numa.fake=1"
    "system_heap.max_order=0"
    "fsck.repair=yes"
    "kunit.enable=0"
  ];

  hardware.bluetooth.enable = false;

  hardware.raspberry-pi."4" = {
    i2c0.enable = true;
    i2c1.enable = true;
    fkms-3d.enable = true;
    touch-ft5406.enable = true;
    apply-overlays-dtmerge.enable = true;
  };

  hardware.deviceTree.enable = true;
  hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
  hardware.deviceTree.overlays = [
    # {
    #   name = "disable-bt";
    #   dtsFile = ../../devicetree/disable-bt-overlay.dts;
    # }
    {
      name = "spi";
      dtsFile = ../../devicetree/spi0-0cs-overlay.dts;
    }
    # {
    #   name = "imx708";
    #   dtsFile = ../../devicetree/imx708-overlay.dts;
    # }
    # {
    #   name = "ov5647";
    #   dtsFile = ./devicetree/ov5647-overlay.dts;
    # }
  ];

  ############################################
  # Kernel Build Configuration
  ############################################
  modules.kernel = {
    enable = true;
    version = "7.0.12";
    src = fetchGit {
      url = "https://github.com/raspberrypi/linux";
      rev = "caad1e7413200adc7804c1f96b7de88742b4a508";
    };

    crossCompile = true;

    extraConfig = with lib.kernel; {
      I2C_ISCH = no;
      DMA_BCM2708 = yes; # https://github.com/raspberrypi/linux/issues/1150
      NET_VENDOR_BROADCOM = yes;
      BROADCOM_PHY = yes;
      BCM54140_PHY = yes;
      BCM7XXX_PHY = yes;
      BCM84881_PHY = yes;
      BCM87XX_PHY = yes;
      BCM_NET_PHYLIB = yes;
      BCM_NET_PHYPTP = yes;

      INPUT_TOUCHSCREEN = yes;
      REGULATOR_RASPBERRYPI_TOUCHSCREEN_ATTINY = lib.mkForce module;
      REGULATOR_RASPBERRYPI_TOUCHSCREEN_V2 = lib.mkForce module;

      # I can't for the life of me figure out why this thing gets selected
      MFD_WM8994 = yes;
      MFD_ARIZONA_I2C = module;
      MFD_ARIZONA_SPI = module;
    };
  };

  ############################################
  # udev Configuration
  ############################################
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="video4linux", KERNEL=="video[01]", GROUP="camera", MODE="660"
    # SUBSYSTEM=="media", KERNEL=="media2", GROUP="camera", MODE="660"
    # SUBSYSTEM=="i2c", GROUP="i2c", MODE="660"

    # https://raspberrypi.stackexchange.com/a/141107
    SUBSYSTEM=="dma_heap", GROUP="camera", MODE="0660"

    # If I ever want to enable SPI
    # SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"

    # Makes video device visible to cage
    ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card2", TAG+="systemd"
  '';

}
