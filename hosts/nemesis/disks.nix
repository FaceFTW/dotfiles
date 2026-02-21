{ ... }:
{
  ############################################
  # Filesystem Config
  ############################################
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5ad1e2a9-84d0-45e1-8663-2b6744626d57";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8466-FDF4";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/citadel" = {
    device = "/dev/disk/by-uuid/293CD3DA2A50BE4A";
    fsType = "ntfs";
    options = [
      "noatime"
      "discard"
      "uid=face"
      "gid=users"
      "dmask=0002"
      "fmask=0002"
      "acl"
      # "windows_names" # This screws up proton
      # "iocharset=utf8"
    ];

  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5813e031-07db-4496-b818-11e165caeee7"; }
  ];
}
