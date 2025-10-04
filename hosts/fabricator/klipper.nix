{
  config,
  pkgs,
  lib,
}:
let
  klipper-fw = pkgs.klipper-firmware.overrideAttrs {
    firmwareConfig = ./klipper/Kconfig;
  };
in
{
  environment.systemPackages = [
    pkgs.klipper
    pkgs.moonraker
    pkgs.mainsail
    klipper-fw
  ];


}
