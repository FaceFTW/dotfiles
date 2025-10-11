{ ... }:
{
  users.users."klipper" = {
    isSystemUser = true;
    group = "klipper";
    extraGroups = [
       "spi"
    ];
  };
  users.groups.klipper = { };

  services.klipper.enable = true;
  services.klipper.user = "klipper";
  services.klipper.group = "klipper";
  services.klipper.firmwares.fabricator.enable = true;
  services.klipper.firmwares.fabricator.configFile = ./klipper/Kconfig;
  services.klipper.configFile = ./klipper/printer.cfg;

  services.moonraker.enable = true;
  services.moonraker.user = "klipper";
  services.moonraker.analysis.enable = true;

  services.mainsail.enable = true;
}
