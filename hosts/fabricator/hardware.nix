{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  ############################################
  # Hardware Configuration
  ############################################
  boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_rpi4;
  boot.kernelModules = [ ];
  boot.blacklistedKernelModules = [
    "dw_hdmi"
    "bluetooth"
    "btusb"
  ];
  hardware.bluetooth.enable = false;

  hardware.raspberry-pi."4".i2c0.enable = true;
  hardware.raspberry-pi."4".i2c1.enable = true;
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  hardware.deviceTree.enable = true;
  hardware.deviceTree.overlays = [
    {
      name = "spi";
      dtsFile = ./devicetree/spi0-0cs-overlay.dts;
    }
    {
      name = "imx708";
      dtsFile = ./devicetree/imx708-overlay.dts;
    }
    {
      name = "display";
      dtsFile = ./devicetree/display-overlay.dts;
    }
    {
      name = "disable-bt";
      dtsFile = ./devicetree/disable-bt-overlay.dts;
    }
    # {
    #   name = "ov5647";
    #   dtsFile = ./devicetree/ov5647-overlay.dts;
    # }
  ];

  ############################################
  # udev Configuration
  ############################################
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{name}=="ADS7846*", SYMLINK+="input/touchscreen"
    SUBSYSTEM=="video4linux", KERNEL=="video[01]", GROUP="camera", MODE="660"
    # https://raspberrypi.stackexchange.com/a/141107
    SUBSYSTEM=="dma_heap", GROUP="video", MODE="0660"
    # If I ever want to enable SPI
    # SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
  '';

}
