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

  boot.initrd.availableKernelModules = [
    "pcie-brcmstb" # required for the pcie bus to work
    "reset-raspberrypi" # required for vl805 firmware to load
  ];
  boot.initrd.systemd.tpm2.enable = false;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.generic-extlinux-compatible.configurationLimit = 2;

  hardware.bluetooth.enable = false;

  # hardware.raspberry-pi."4" = {
  #   apply-overlays-dtmerge.enable = true;
  #   poe-plus-hat.enable = true;
  # };

  hardware.deviceTree.enable = true;
  hardware.deviceTree.filter = "bcm2837-rpi-zero-2*";

  ############################################
  # udev Configuration
  ############################################
  services.udev.enable = true;
  # services.udev.extraRules = ''
  # '';

}
