{ ... }:
{
  services.klipper.enable = true;
  services.klipper.firmwares.fabricator.enable = true;
  services.klipper.firmwares.fabricator.configFile = ./klipper/Kconfig;
  services.klipper.firmwares.fabricator.serial =
    /dev/serial/by-id/usb-Klipper_stm32g0b0xx_36004C0001504E5238363120-if00;
  services.klipper.configFile = ./klipper/printer.cfg;

  services.moonraker.enable = true;
  services.moonraker.group = "klipper";
  services.moonraker.user = "klipper";
  services.moonraker.analysis.enable = true;

  services.mainsail.enable = true;
}
