{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.koito.enable = true;
  services.koito.environment.KOITO_CONFIG_DIR = "/mnt/motorway/var/koito";

  systemd.services.koito = {
    description = "Koito - modern scrobbler";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = lib.getExe config.services.koito.package;
      StateDirectory = "koito";

      ProtectSystem = "strict";
      ReadWritePaths = [ "/mnt/motorway/var/koito" ];
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateMounts = true;
      ProtectControlGroups = true;
      ProtectKernelTunables = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      UMask = "0077";

      CapabilityBoundingSet = [ "" ];
      NoNewPrivileges = true;

      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectClock = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
      ];

      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];

      PrivateUsers = true;

      LockPersonality = true;
      ProtectHostname = true;
      RestrictRealtime = true;
      RestrictNamespaces = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      DeviceAllow = [ "" ];
    };
  };

  modules.nginx.reverse-proxy.koito = {
    localPort = 4110;
    serverName = "koito.faceftw.dev";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/motorway/var/koito 0755 koito koito - -"
  ];
}
