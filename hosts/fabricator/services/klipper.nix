{
  ...
}:
{
  modules.users.system.klipper.home = "/var/lib/klipper";
  modules.users.system.klipper.extraGroups = [ "camera" ];

  services.klipper = {
    enable = true;
    user = "klipper";
    group = "klipper";
    firmwares.fabricator.enable = true;
    firmwares.fabricator.enableKlipperFlash = true;
    firmwares.fabricator.configFile = ./klipper-build-config;
    firmwares.fabricator.serial = "/dev/serial/by-id/usb-Klipper_stm32g0b0xx_36004C0001504E5238363120-if00";
    configFile = ./klipper.cfg;
  };
}
