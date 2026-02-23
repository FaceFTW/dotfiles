{
  pkgs,
  ...
}:
{
  ############################################
  # Hardware Configuration
  ############################################
  boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_rpi4;
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
    "snd_bcm2835.enable_headphones=0"
    "snd_bcm2835.enable_hdmi=0"
    "numa=fake=1"
    "system_heap.max_order=0"
    # "smsc95xx.macaddr=DC:A6:32:0B:44:53"
    "vc_mem.mem_base=0x3ec00000"
    "vc_mem.mem_size=0x40000000"
    "fsck.repair=yes"
    "rootwait"
    "cfg80211.ieee80211_regdom=US"
  ];

  hardware.bluetooth.enable = false;

  hardware.raspberry-pi."4".i2c0.enable = true;
  hardware.raspberry-pi."4".i2c1.enable = true;
  # hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  hardware.deviceTree.enable = true;
  hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
  hardware.deviceTree.overlays = [
    # {
    #   name = "disable-bt";
    #   dtsFile = ./devicetree/disable-bt-overlay.dts;
    # }
    # {
    #   name = "spi";
    #   dtsFile = ./devicetree/spi0-0cs-overlay.dts;
    # }
    # {
    #   name = "imx708";
    #   dtsFile = ./devicetree/imx708-overlay.dts;
    # }
    {
      name = "display";
      dtsFile = ./devicetree/display-overlay.dts;
    }
    {
      name = "kms";
      dtsFile = ./devicetree/kms-overlay.dts;
    }
    # {
    #   name = "ov5647";
    #   dtsFile = ./devicetree/ov5647-overlay.dts;
    # }
  ];

  ############################################
  # udev Configuration
  ############################################
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{name}=="ADS7846*", SYMLINK+="input/touchscreen"
    SUBSYSTEM=="video4linux", KERNEL=="video[01]", GROUP="camera", MODE="660"
    # https://raspberrypi.stackexchange.com/a/141107
    SUBSYSTEM=="dma_heap", GROUP="video", MODE="0660"
    # If I ever want to enable SPI
    # SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
  '';

}
