{
  config,
  lib,
  ...
}:
let
  # TODO This is to prevent overlapping with the nixpkgs "services"
  # attribute set
  service = config.service;
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    types
    ;

in
{
  options.service.syncthing = {
    enable = mkEnableOption "Enable Syncthing";
    key = mkOption {
      description = "path of the `key.pem` that Syncthing should use";
      type = types.str;
    };
    cert = mkOption {
      description = "path of the `cert.pem` that Syncthing should use";
      type = types.str;
    };
    accessibleFolders = mkOption {
      description = "List of paths that should be R/W-able by Syncthing";
      type = types.listOf types.str;
    };
    folderOwner = mkOption {
      description = "Name of the user that owns all folders in accessibleFolders";
      type = types.str;
    };
  };

  config = mkMerge [
    (mkIf service.syncthing.enable {
      ############################################
      # Syncthing
      ############################################
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
      services.syncthing.key = service.syncthing.key;
      services.syncthing.cert = service.syncthing.cert;

      systemd.services.syncthing.serviceConfig.UMask = "0007";
      systemd.tmpfiles.rules = (
        map (
          folder: "d ${folder} 2770 ${service.syncthing.folderOwner} syncthing"
        ) service.syncthing.accessibleFolders
      );

    })
  ];
}
