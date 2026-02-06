{ config, pkgs, ... }:
{

  services.smartd.enable = true;
  services.smartd.defaults.monitored = "-a -m <nomailer> -M exec ${pkgs.smartd-notif-event}/bin/smartd-notif-event -s (S/../.././03|L/../(2|4)/./04)";

  systemd.services.ugreen-led-mons = {
    wantedBy = [ "sysinit.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.ugreen-led-mon}/bin/ugreen-led-mon";
  };

  ############################################
  # Jellyfin
  ############################################
  users.users.jellyfin = {
    isSystemUser = true;
    home = "/mnt/motorway/var/jellyfin";
    group = "jellyfin";
  };
  users.groups.jellyfin = { };
  services.jellyfin.enable = true;
  services.jellyfin.cacheDir = "/mnt/motorway/var/jellyfin/cache";
  services.jellyfin.configDir = "/mnt/motorway/var/jellyfin/config";
  services.jellyfin.dataDir = "/mnt/motorway/var/jellyfin/data";
  services.jellyfin.logDir = "/mnt/motorway/var/jellyfin/logs";
  services.jellyfin.openFirewall = true;
  services.jellyfin.user = "jellyfin";
  services.jellyfin.group = "jellyfin";
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

  ############################################
  # Syncthing
  ############################################
  service.syncthing.enable = true;
  service.syncthing.key = "/run/secrets/syncthing/key.pem";
  service.syncthing.cert = "/run/secrets/syncthing/cert.pem";
  service.syncthing.accessibleFolders = [ "/mnt/motorway/Workspaces" ];
  service.syncthing.folderOwner = "face";

  ############################################
  # Immich
  ############################################
  users.users.immich = {
    isSystemUser = true;
    home = "/mnt/motorway/var/immich";
    group = "immich";
  };
  users.groups.immich = { };
  services.immich.enable = true;
  services.immich.user = "immich";
  services.immich.group = "immich";
  services.immich.openFirewall = true;
  services.immich.secretsFile = config.sops.secrets.immich_secrets.path;
  services.immich.mediaLocation = "/mnt/motorway/var/immich/data";
  services.immich.database.enable = true;
  services.immich.database.enableVectorChord = true;
  users.users.postgres = {
    isSystemUser = true;
    home = "/mnt/motorway/var/postgres";
    group = "postgres";
  };
  services.postgresql.dataDir = "/mnt/motorway/var/postgres";

  systemd.timers."immich-mirror" = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "*-*-* 3:00:00";
    timerConfig.Persistent = true;
  };
  systemd.services."immich-mirror" = {
    wants = [
      "mnt-archive.mount"
      "mnt-motorway.mount"
    ];
    serviceConfig.Type = "oneshot";
    script = ''

      token=$(cat /run/secrets/pushover_api_key)
      user=$(cat /run/secrets/pushover_user_key)

      ${pkgs.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
        --form-string "title=Archiver - Immich Mirror" \
        --form-string "message=Starting backup" \
        https://api.pushover.net/1/messages.json


      ${pkgs.rsync}/bin/rsync -aPt \
          --archive \
          --partial \
          --progress \
          --delete-before \
          /mnt/motorway/var/immich/data/ \
          /mnt/archive/immich

      ${pkgs.coreutils}/bin/chown --recursive face:users /mnt/archive/immich


      ${pkgs.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
        --form-string "title=Archiver - Immich Mirror" \
        --form-string "message=Backup Job completed. Check logs for more info" \
        https://api.pushover.net/1/messages.json
    '';
  };

  ############################################
  # Linkwarden
  ############################################
  users.users.linkwarden = {
    isSystemUser = true;
    home = "/mnt/motorway/var/linkwarden";
    group = "linkwarden";
  };
  users.groups.linkwarden = { };
  services.linkwarden.enable = true;
  services.linkwarden.user = "linkwarden";
  services.linkwarden.group = "linkwarden";

  services.linkwarden.port = 3015;
  services.linkwarden.openFirewall = true;

  services.linkwarden.cacheLocation = "/mnt/motorway/var/linkwarden/cache";
  services.linkwarden.storageLocation = "/mnt/motorway/var/linkwarden/data";
  services.linkwarden.secretFiles.NEXTAUTH_SECRET = "/run/secrets/linkwarden_nextauth_secret";
  services.linkwarden.secretFiles.POSTGRES_PASSWORD = "/run/secrets/linkwarden_postgres_password";
  services.linkwarden.enableRegistration = true;

  ############################################
  # Mirror to Backup
  ############################################
  systemd.timers."archive-offline-mirror" = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "weekly";
    timerConfig.Persistent = true;
  };
  systemd.services."archive-offline-mirror" = {
    wants = [
      "mnt-archive.mount"
      "mnt-freeman.mount"
    ];
    serviceConfig.Type = "oneshot";
    script = ''

      token=$(cat /run/secrets/pushover_api_key)
      user=$(cat /run/secrets/pushover_user_key)

      ${pkgs.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
        --form-string "title=Archive Offline Mirror" \
        --form-string "message=Starting backup job" \
        https://api.pushover.net/1/messages.json


      ${pkgs.rsync}/bin/rsync -aPt \
          --archive \
          --partial \
          --progress \
          --delete-before \
          --exclude /SteamBackups \
          --exclude /Misc_Large \
          --exclude /SteamLibrary \
          /mnt/archive/ \
          /mnt/freeman

      ${pkgs.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
        --form-string "title=Archive Offline Mirror" \
        --form-string "message=Backup Job completed. Check logs for more info" \
        https://api.pushover.net/1/messages.json
    '';

  };
}
