{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    ;
  backrest = config.servicesCustom.backrest;
in
{
  options.servicesCustom.backrest = {
    enable = mkEnableOption "Backrest backup server";
    configPath = mkOption {
      type = types.str;
    };
    dataDir = mkOption {
      type = types.str;
    };
    cacheDir = mkOption {
      type = types.str;
    };
    user = mkOption {
      type = types.str;
    };
    group = mkOption {
      type = types.str;
    };

  };

  config = mkIf backrest.enable {
    environment.systemPackages = [
      pkgs.restic
      pkgs.backrest
    ];

    systemd.services.backrest = {
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];

      environment.BACKREST_RESTIC_COMMAND = "${pkgs.restic}/bin/restic";
      environment.BACKREST_CONFIG = "${backrest.configPath}";
      environment.BACKREST_DATA = "${backrest.dataDir}";
      environment.XDG_CACHE_HOME = "${backrest.cacheDir}";

      serviceConfig.User = "${backrest.user}";
      serviceConfig.Group = "${backrest.group}";
      serviceConfig.ExecStart = "${pkgs.backrest}/bin/backrest";

      serviceConfig.AmbientCapabilities = "CAP_DAC_READ_SEARCH";
      serviceConfig.CapabilityBoundingSet = "CAP_DAC_READ_SEARCH";
    };

  };
}
