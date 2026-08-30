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
    "numa=fake=1"
    "system_heap.max_order=0"
    "fsck.repair=yes"
    "kunit.enable=0"
  ];

  hardware.bluetooth.enable = false;

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    # poe-plus-hat.enable = true;
  };

  hardware.raspberry-pi.configtxt.deviceTreeOverlays."board-type=0x11" = [
     {
       rpi-poe-plus = {
         poe_fan_temp0 = 40000;
         poe_fan_temp0_hyst = 2000;
         poe_fan_temp1 = 45000;
         poe_fan_temp1_hyst = 2000;
         poe_fan_temp2 = 50000;
         poe_fan_temp2_hyst = 2000;
         poe_fan_temp3 = 55000;
         poe_fan_temp3_hyst = 5000;
       };
     }
   ];

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
    enable = true;
    version = "7.2.2";
    src = fetchGit {
      url = "https://github.com/raspberrypi/linux";
      rev = "003a7d95a5c97f699cb62ffcda6d618130855052";
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
  # services.udev.extraRules = ''
  # '';

}
