{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  programs.hyprland.enable = true;
  programs.hyprland.systemd.setPath.enable = true;
  programs.hyprland.withUWSM = true;
}
