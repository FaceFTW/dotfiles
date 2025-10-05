{
  config,
  pkgs,
  lib,
  ...
}:
let
  secretsBase = config.packages.secrets.base;
  wslForwarding = config.packages.secrets.wslGpgForwarding;
  inherit (lib)
    mkIf
    mkEnableOption
    lists
    ;
in
{
  options.packages.secrets.base = mkEnableOption "Secrets Management Utilities"
}
