{ ... }:
{
  services.klipper.enable = true;
  services.klipper.firmwares.fabricator.enable = true;
  services.klipper.firmwares.fabricator.configFile = ./klipper/Kconfig;
  services.klipper.configFile = ./klipper/printer.cfg;

  services.moonraker.enable = true;
  services.moonraker.analysis.enable = true;

  services.mainsail.enable = true;
}
