{
  config,
  pkgs,
  lib,
  ...
}:
let
  nodejs = config.packages.nodejs;

  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.packages.nodejs.node = mkEnableOption "NodeJS";
  options.packages.nodejs.biome = mkEnableOption "Install Biome";

  config = mkMerge [
    ############################################
    # NodeJS
    ############################################
    (mkIf nodejs.node {
      environment.systemPackages = [
        pkgs.nodejs_24
      ];
    })
    ############################################
    # Biome
    ############################################
    (mkIf nodejs.biome {
      environment.systemPackages = [
        pkgs.biome
      ];
    })

  ];
}
