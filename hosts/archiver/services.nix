{ config, pkgs, ... }:
{

  services.smartd.enable = true;
  services.smartd.defaults.monitored = "-a -m <nomailer> -M exec ${pkgs.smartd-notif-event}/bin/smartd-notif-event -s (S/../.././03|L/../(2|4)/./04)";

  systemd.services.ugreen-led-mons = {
    wantedBy = [ "sysinit.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.ugreen-led-mon}/bin/ugreen-led-mon";
  };

  # Autostart btop monitor as a kiosk
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "${pkgs.btop}/bin/btop --config /home/face/.config/btop/btop.conf --preset 1 --force-utf --no-tty"
    ];
    serviceConfig.User = "face"; # this is unconventional
    serviceConfig.Group = "users";
  };

  ############################################
  # SSH Server
  ############################################
  servicesCustom.ssh-server.enable = true;
  servicesCustom.ssh-server.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuQw4U+Wam1gjuEXyH/cObZfnfYiA/LPF0kjQPFTz9x face@manifold-wsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3fuhneqp6s6Ye9hHb60QrXq8vlu5INzeKlgiPtO5Pq alex@faceftw.dev"
  ];

  ############################################
  # Jellyfin
  ############################################
  systemUser.jellyfin.home = "/mnt/motorway/var/jellyfin";

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
  servicesCustom.syncthing.enable = true;
  servicesCustom.syncthing.key = "/run/secrets/syncthing/key.pem";
  servicesCustom.syncthing.cert = "/run/secrets/syncthing/cert.pem";
  servicesCustom.syncthing.accessibleFolders = [ "/mnt/motorway/Workspaces" ];
  servicesCustom.syncthing.folderOwner = "face";

  ############################################
  # Immich
  ############################################
  systemUser.immich.home = "/mnt/motorway/var/immich";

  services.immich.enable = true;
  services.immich.user = "immich";
  services.immich.group = "immich";
  services.immich.openFirewall = true;
  services.immich.secretsFile = config.sops.secrets.immich_secrets.path;
  services.immich.mediaLocation = "/mnt/motorway/var/immich/data";
  services.immich.database.enable = true;
  services.immich.database.enableVectorChord = true;

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
  systemUser.linkwarden.home = "/mnt/motorway/var/linkwarden";

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
  # Postgres (Shared)
  ############################################
  systemUser.postgres.home = "/mnt/motorway/var/postgres";
  services.postgresql.dataDir = "/mnt/motorway/var/postgres";

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
