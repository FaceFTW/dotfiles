{
  pkgs,
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
    "numa=fake=1"
    "system_heap.max_order=0"
    "fsck.repair=yes"
    "kunit.enable=0"
    "console=ttyS0,115200n8"
    "console=tty0"
  ];

  hardware.bluetooth.enable = false;

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    poe-plus-hat.enable = true;
  };

  hardware.deviceTree.enable = true;
  hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
  hardware.deviceTree.overlays = [
    {
      name = "disable-bt";
      dtsFile = ../../devicetree/disable-bt-overlay.dts;
    }
  ];

  ############################################
  # Kernel Build Configuration
  ############################################
  modules.kernel = {
    version = "6.18.32";
    src = pkgs.fetchgit {
      url = "https://github.com/raspberrypi/linux";
      rev = "bb5a64adb1b761406d0e3b6570c3d2668e9198f8";
      hash = "sha256-rpWHYPW4JotPczjB8ENzX0m+IypHX24N3GTK8s8d1dM=";
      # hash = lib.fakeHash;
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

}
