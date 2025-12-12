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
    # NVMe Disks
    # These are used primarily as fast-memory + swap.
    # These drives aren't NAS-grade (literally pulled from scrap computers)
    # Two swap partitions is weird but at least it "should" work

    # NVME0
    disk.nvme0.type = "disk";
    disk.nvme0.device = "/dev/nvme0n1";
    disk.nvme0.content.type = "gpt";
    disk.nvme0.content.partitions = {
      # Swap 0
      swap0.size = "8GB";
      swap0.content.type = "swap";
      swap0.priority = 1;

      # Motorway 0
      motorway0.size = "100%";
      motorway0.content.type = "btrfs";
      motorway0.content.extraArgs = [ "" ];
	#   motorway0
    };

    # NVMe1
  };

}
