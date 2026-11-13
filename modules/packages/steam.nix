{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.packages.steam = mkEnableOption "Valve Steam";

  config = mkMerge [
    ############################################
    # Valve Steam
    ############################################
    (mkIf packages.steam {
      programs.steam.enable = true;
      programs.steam.remotePlay.openFirewall = true;
      programs.steam.localNetworkGameTransfers.openFirewall = true;

      programs.steam.protontricks.enable = true;

      programs.steam.package = pkgs.steam.override {
        extraPkgs = pkgs: [
          pkgs.mesa-demos
          pkgs.gamemode
        ];
      };
    })
  ];
}
