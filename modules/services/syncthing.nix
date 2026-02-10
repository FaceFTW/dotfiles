{
  config,
  pkgs,
  lib,
  ...
}:
let
  servicesCustom = config.servicesCustom;
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    types
    ;

in
{
  options.servicesCustom.syncthing = {
    enable = mkEnableOption "Enable Syncthing";
    user-level = mkEnableOption "Syncthing as user-level service";
    key = mkOption {
      description = "path of the `key.pem` that Syncthing should use";
      type = types.str;
    };
    cert = mkOption {
      description = "path of the `cert.pem` that Syncthing should use";
      type = types.str;
    };
    user = mkOption {
      description = "name of the user that Syncthing user-level service is for";
      type = types.str;
      default = "face";
    };
    accessibleFolders = mkOption {
      description = "List of paths that should be R/W-able by Syncthing";
      type = with types; listOf str;
      default = [ ];
    };
    folderOwner = mkOption {
      description = "Name of the user that owns all folders in accessibleFolders";
      type = types.str;
      default = "syncthing";
    };

  };

  config = mkMerge [
    (mkIf (servicesCustom.syncthing.enable && !servicesCustom.syncthing.user-level) {
      # https://nitinpassa.com/running-syncthing-as-a-system-user-on-nixos/
      users.users.syncthing = {
        isSystemUser = true;
        home = "/var/lib/syncthing";
        group = "syncthing";
        extraGroups = [ "users" ];
      };
      users.groups.syncthing = { };
      services.syncthing.enable = true;
      services.syncthing.openDefaultPorts = true;
      services.syncthing.key = servicesCustom.syncthing.key;
      services.syncthing.cert = servicesCustom.syncthing.cert;

      systemd.services.syncthing.serviceConfig.UMask = "0007";
      systemd.tmpfiles.rules = (
        map (folder: ''
          d ${folder} 2770 ${servicesCustom.syncthing.folderOwner} syncthing - -
        '') servicesCustom.syncthing.accessibleFolders
      );

    })
    (mkIf (servicesCustom.syncthing.enable && servicesCustom.syncthing.user-level) {
      networking.firewall.allowedTCPPorts = [ 22000 ];
      networking.firewall.allowedUDPPorts = [
        21027
        22000
      ];

      home-manager.users.${servicesCustom.syncthing.user} = {
        # home.file.".config/syncthing/cert.pem" = "/run/secrets/syncthing/cert.pem";
        # home.file.".config/syncthing/key.pem" = "/run/secrets/syncthing/key.pem";
      };

      systemd.user.tmpfiles.rules = [
        "L /home/${servicesCustom.syncthing.user}/.config/syncthing/cert.pem - - - - /run/secrets/syncthing_cert.pem"
        "L /home/${servicesCustom.syncthing.user}/.config/syncthing/key.pem - - - - /run/secrets/syncthing_key.pem"
      ];

      systemd.user.services.syncthing = {
        description = "Syncthing service";
        after = [ "network.target" ];
        wantedBy = [
          "default.target"
        ];

        environment.STNORESTART = "yes";
        environment.STNOUPGRADE = "yes";

        serviceConfig.ExecStart = "${pkgs.syncthing}/bin/syncthing serve --no-browser --no-restart";
        serviceConfig.Restart = "on-failure";
        serviceConfig.RestartSec = 1;
        serviceConfig.SuccessExitStatus = "3 4";
        serviceConfig.RestartForceExitStatus = "3 4";

        serviceConfig.ProtectSystem = "full";
        serviceConfig.PrivateTmp = true;
        serviceConfig.SystemCallArchitectures = "native";
        serviceConfig.MemoryDenyWriteExecute = true;
        serviceConfig.NoNewPrivileges = true;
      };

    })

  ];
}
