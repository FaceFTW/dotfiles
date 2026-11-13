{ ... }:
{
  ############################################
  # Filesystem Config
  ############################################
  fileSystems."/" = {
    device = "/dev/disk/by-label/theseus";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];
}
