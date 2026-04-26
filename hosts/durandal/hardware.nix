{
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
  # udev Configuration
  ############################################
  services.udev.enable = true;
  # services.udev.extraRules = ''
  # '';

}
