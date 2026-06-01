{
  pkgs,
  ...
}:
{
  ############################################
  # Mirror Jobs
  ############################################
  servicesCustom.mirror.archive-freeman = {
    notification-title = "Archiver - Archive to Freeman Mirror";
    cron = "Sun *-*-* 09:00:00";
    source = "/mnt/archive";
    destination = "/mnt/freeman";
    mounts = [
      "mnt-archive.mount"
      "mnt-freeman.mount"
    ];
    exclude = [
      "/SteamBackups"
      "/Misc_Large"
      "/SteamLibrary"
    ];
    filters = [
      "protect Autorun.inf"
      "protect .VolumeIcon.ico"
      "protect .VolumeIcon.icns"
    ];
  };

  # servicesCustom.mirror.archive-kleiner = {
  #   notification-title = "Archiver - Archive to Kleiner Mirror";
  #   cron = "Sun *-*-* 10:00:00";
  #   source = "/mnt/archive";
  #   destination = "/mnt/kleiner";
  #   mounts = [
  #     "mnt-archive.mount"
  #     "mnt-freeman.mount"
  #   ];
  #   exclude = [
  #     "/SteamBackups"
  #     "/Misc_Large"
  #     "/SteamLibrary"
  #     "/TV\ Shows"
  #     "/Movies"
  #   ];
  #   filters = [
  #     "protect Autorun.inf"
  #     "protect .VolumeIcon.ico"
  #     "protect .VolumeIcon.icns"
  #   ];
  # };

  servicesCustom.mirror.immich-archive = {
    notification-title = "Archiver - Immich to Archive Mirror";
    cron = "*-*-* 3:00:00";
    source = "/mnt/motorway/var/immich/data";
    destination = "/mnt/archive/immich";
    mounts = [
      "mnt-archive.mount"
      "mnt-motorway.mount"
    ];
    post-mirror-cmds = ''
      ${pkgs.coreutils}/bin/chown --recursive face:users /mnt/archive/immich
    '';
  };

  servicesCustom.mirror.workspace-archive = {
    notification-title = "Archiver - Workspaces to Archive Mirror";
    cron = "*-*-* 4:00:00";
    source = "/mnt/motorway/Workspaces";
    destination = "/mnt/archive/Workspaces";
    mounts = [
      "mnt-archive.mount"
      "mnt-motorway.mount"
    ];
    post-mirror-cmds = ''
      ${pkgs.coreutils}/bin/chown --recursive face:users /mnt/archive/Workspaces
    '';
  };

  servicesCustom.mirror.vault-archive = {
    notification-title = "Archiver - Vault to Archive Mirror";
    cron = "*-*-* 4:00:00";
    source = "/mnt/motorway/Vaults";
    destination = "/mnt/archive/Vaults";
    mounts = [
      "mnt-archive.mount"
      "mnt-motorway.mount"
    ];
    post-mirror-cmds = ''
      ${pkgs.coreutils}/bin/chown --recursive face:users /mnt/archive/Vaults
    '';
  };
}
