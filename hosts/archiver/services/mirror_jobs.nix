{
  pkgs,
  ...
}:
{
  ############################################
  # Mirror Jobs
  ############################################
  servicesCustom.mirror.archive-freeman = {
    notification-title = "Archiver - Freeman Mirror";
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

  servicesCustom.mirror.archive-kleiner = {
    notification-title = "Archiver - Kleiner Mirror";
    cron = "Sun *-*-* 10:00:00";
    source = "/mnt/archive";
    destination = "/mnt/kleiner";
    mounts = [
      "mnt-archive.mount"
      "mnt-freeman.mount"
    ];
    exclude = [
      "/SteamBackups"
      "/Misc_Large"
      "/SteamLibrary"
      "/TV\ Shows"
      "/Movies"
    ];
    filters = [
      "protect Autorun.inf"
      "protect .VolumeIcon.ico"
      "protect .VolumeIcon.icns"
    ];
  };

  servicesCustom.mirror.archive-immich = {
    notification-title = "Archiver - Immich Mirror";
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
}
