{
  inputs,
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
  imports = [ inputs.nixos-wsl.nixosModules.default ];
  options.packages.zed.enable = mkEnableOption "Zed Editor";
  options.packages.zed.wslFixes = mkEnableOption "Systemd service to start the Zed remote server automatically";

  config = mkMerge [
    (mkIf packages.zed.enable {
      environment.systemPackages = [
        pkgs.zed-editor
        pkgs.openssl_3
      ];
    })
    (mkIf packages.zed.wslFixes {
      wsl.extraBin = [
        { src = "${pkgs.coreutils}/bin/uname"; }
        { src = "${pkgs.coreutils}/bin/mkdir"; }
        { src = "${pkgs.coreutils}/bin/cp"; }
      ];
    })

  ];
}
