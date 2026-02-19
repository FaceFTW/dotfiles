{ pkgs, ... }:
{
  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    ARRAY /dev/md/archive level=raid1 num-devices=2 metadata=1.2 UUID=4b2a84b8:7dc68fd2:fc13310b:d33a87d7
       devices=/dev/sda1,/dev/sdb1
    ARRAY /dev/md/motorway level=raid1 num-devices=2 metadata=1.2 UUID=b24a0956:4cae3b00:0885ea30:b409d016
       devices=/dev/nvme0n1p2,/dev/nvme1n1p2

    PROGRAM ${pkgs.mdadm-notif-event}/bin/mdadm-notif-event
  '';

  disko.devices = {
    ############################################
    # Internal eMMC
    ############################################
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
      root.content.mountpoint = "/";
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

    ############################################
    # NVMe Disks
    ############################################
    # These are used primarily as fast-memory + swap.
    # These drives aren't NAS-grade (literally pulled from scrap computers)
    # Two swap partitions is weird but at least it "should" work

    disk.nvme0.type = "disk";
    disk.nvme0.device = "/dev/nvme0n1";
    disk.nvme0.content.type = "gpt";
    disk.nvme0.content.partitions = {
      swap0.size = "8G";
      swap0.content.type = "swap";
      swap0.priority = 1;

      motorway0.size = "100%";
      motorway0.content.type = "mdraid";
      motorway0.content.name = "motorway";
    };

    disk.nvme1.type = "disk";
    disk.nvme1.device = "/dev/nvme1n1";
    disk.nvme1.content.type = "gpt";
    disk.nvme1.content.partitions = {
      swap1.size = "8G";
      swap1.content.type = "swap";
      swap1.priority = 1;

      motorway1.size = "100%";
      motorway1.content.type = "mdraid";
      motorway1.content.name = "motorway";
    };

    mdadm.motorway.type = "mdadm";
    mdadm.motorway.level = 1; # RAID 1
    mdadm.motorway.content.type = "gpt";
    mdadm.motorway.content.partitions = {
      motorway.size = "100%";
      motorway.content.type = "filesystem";
      motorway.content.format = "btrfs";
      motorway.content.mountpoint = "/mnt/motorway";
      motorway.content.mountOptions = [ "noatime" ];
    };

    ############################################
    # SATA HDDs
    ############################################
    # The slow storage devices
    # Separate mdadm volume for this

    disk.sda.type = "disk";
    disk.sda.device = "/dev/sda";
    disk.sda.content.type = "gpt";
    disk.sda.content.partitions = {
      archive0.size = "100%";
      archive0.content.type = "mdraid";
      archive0.content.name = "archive";
    };

    disk.sdb.type = "disk";
    disk.sdb.device = "/dev/sdb";
    disk.sdb.content.type = "gpt";
    disk.sdb.content.partitions = {
      archive1.size = "100%";
      archive1.content.type = "mdraid";
      archive1.content.name = "archive";
    };

    mdadm.archive.type = "mdadm";
    mdadm.archive.level = 1; # RAID 1
    mdadm.archive.content.type = "gpt";
    mdadm.archive.content.partitions = {
      library.size = "100%";
      library.content.type = "filesystem";
      library.content.format = "btrfs";
      library.content.mountpoint = "/mnt/archive";
      library.content.mountOptions = [
        "compress=zstd:9"
        "noatime"
      ];
    };

  };

  # Bind mounts for Samba Shares
  # Assumes we made the /export directory with perms
  fileSystems."/export/motorway".device = "/mnt/motorway";
  fileSystems."/export/motorway".depends = [ "/mnt/motorway" ];
  fileSystems."/export/motorway".options = [ "bind" ];

  fileSystems."/export/archive".device = "/mnt/archive";
  fileSystems."/export/archive".depends = [ "/mnt/archive" ];
  fileSystems."/export/archive".options = [ "bind" ];

  # This is an external SSD to be used as a "offline mirror" separate from
  # the main MDADM array. Since this is external, it is not managed by disko
  fileSystems."/mnt/freeman".device = "/dev/disk/by-partuuid/b976fd48-c9e9-4c0a-aed1-b105f2bfe7c7";
  fileSystems."/mnt/freeman".fsType = "exfat";
  fileSystems."/mnt/freeman".options = [
    "uid=face"
    "gid=users"
    "nofail"
  ];
  fileSystems."/mnt/freeman".depends = [
    "/mnt/archive"
    "/mnt/motorway"
  ];

  # Another external SSD, but smaller
  fileSystems."/mnt/kleiner".device = "/dev/disk/by-partuuid/c524f2dc-4057-4b30-80c1-a70397c1bbd2";
  fileSystems."/mnt/kleiner".fsType = "exfat";
  fileSystems."/mnt/kleiner".options = [
    "uid=face"
    "gid=users"
    "nofail"
  ];
  fileSystems."/mnt/kleiner".depends = [
    "/mnt/archive"
    "/mnt/motorway"
  ];

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/"
    "/mnt/archive"
    "/mnt/motorway"
  ];

}
