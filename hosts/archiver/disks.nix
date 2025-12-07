{
  disko.devices = {
    # Internal eMMC
    # This is the core "OS"
    disk.internal.type = "disk";
    disk.internal.device = "/dev/mmcblk0";
    disk.internal.content.type = "gpt";
    disk.internal.content.partitions = {
      # Boot Partition
      ESP.priority = 1;
      ESP.size = "500M";
      ESP.type = "EF00";
      ESP.start = "1M";
      ESP.end = "128M";
      ESP.content.type = "filesystem";
      ESP.content.format = "vfat";
      ESP.content.mountpoint = "/boot";
      ESP.content.mountOptions = [ "umask=0077" ];

      # Root Partition
      root.size = "100%";
      root.content.type = "btrfs";
      root.content.extraArgs = [ "-f" ];
      root.content.mountpoint = "/partition-root";
      root.content.subvolumes = {
        "/".mountpoint = "/";

        "/home" = {
          mountOptions = [ "compress=zstd" ];
          mountpoint = "/home";
        };

        "/nix" = {
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
          mountpoint = "/nix";
        };
      };

    };
  };

  # NVMe Disks
  # These are used primarily as fast-caches + swap. Not the most optimal use of such a system
  # but we take those
}
