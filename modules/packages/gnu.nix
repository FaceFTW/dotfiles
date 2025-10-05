{
  config,
  pkgs,
  lib,
  ...
}:
let
  gnuMake = config.packages.gnuMake;
  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.packages.gnuMake = mkEnableOption "GNU Make + Related Tools";

  config = mkMerge [
    (mkIf gnuMake {
      environment.systemPackages = [
        pkgs.gnumake
        pkgs.autoconf
        pkgs.automake
      ];
    })
  ];

}
