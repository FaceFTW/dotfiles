{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  zoneSpec =
    with types;
    submodule {
      options.apex = mkOption {
        type = types.str;
        description = "Subdomain Apex to use on top of the apex of `faceftw.dev`";
      };

      options.ipAddress = mkOption {
        type = types.str;
        description = "IP Address to use for the `A` record. Only expects IPv4";
      };

      options.additionalSubdomains = mkOption {
        type = with types; listOf str;
        description = "Additional subdomain records on _with_ the subdomain apex to register to the zone with the same IP address";
        default = [ ];
      };

      options.cnameRecords = mkOption {
        type = with types; listOf (listOf str);
        description = "List of CNAME records to generate. First item is always the subdomain wihtout the apex, second is the domain to point to";
        default = [ ];
      };
    };

  mkZoneFile =
    name:
    {
      apex,
      ipAddress,
      additionalSubdomains,
      cnameRecords,
      ...
    }:
    let
      apexRecord = "@       IN A ${ipAddress}";
      otherARecords = lib.concatMapStrings (x: "${x} IN A ${ipAddress}\n") additionalSubdomains;
      cnameRecordsRendered = lib.concatMapStrings (
        x: "${lib.elemAt x 0} IN CNAME ${lib.elemAt x 1}\n"
      ) cnameRecords;

    in
    {
      enable = true;
      user = "named";
      group = "named";
      mode = "0600";
      text = ''
        $ORIGIN ${apex}.faceftw.dev.
        $TTL    60   ; 86400 - 1 day

        @                   IN SOA  dns-internal.faceftw.dev. admin-internal.faceftw.dev. (
                              20260902    ; Serial
                              3600        ; Refresh
                              300         ; Retry
                              3600        ; Expire
                              300)        ; Negative Cache TT

        @                      IN NS     ${apex}.faceftw.dev.

        ${apexRecord}
        ${otherARecords}
        ${cnameRecordsRendered}
      '';
    };

  mkZoneDef = name: { apex, ... }: {
    name = "${apex}.faceftw.dev";
    file = "/etc/bind/zones/${apex}.faceftw.dev.zone";
    master = true;
  };

  zoneCfg = config.modules.services.bind-zone;
in
{

  options.modules.services.bind-zone = mkOption {
    type = with types; attrsOf zoneSpec;
    default = { };
  };

  config = {
    services.bind.zones = (
      lib.attrValues (
        lib.mapAttrs' (name: zoneDef: {
          inherit name;
          value = (mkZoneDef name zoneDef);
        }) zoneCfg
      )
    );

    environment.etc = lib.mapAttrs' (name: zoneDef: {
      name = "bind/zones/${name}.faceftw.dev.zone";
      value = (mkZoneFile name zoneDef);
    }) zoneCfg;
  };
}
