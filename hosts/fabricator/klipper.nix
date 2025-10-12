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
  services.moonraker.settings.authorization.trustedClients = [
    "10.0.0.0/8"
    "127.0.0.0/8"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "FE80::/10"
    "::1/128"
  ];
  services.moonraker.settings.authorization.cors_domains = [
    "*://*.local"
    "*://*.lan"
  ];

  services.mainsail.enable = true;
}
