{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Allow User access to SPI
  users.groups.spi = { };

  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
    SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{name}=="ADS7846*", SYMLINK+="input/touchscreen"
  '';

}
