{ ... }:
let
  fromJsonFile =
    file: (builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile file)));
in
{
  imports = [
    ./hypr.nix

  ];

  # services.xserver.enable = true;
  # services.xserver.displaymanager.lightdm.enable = true;
  # services.xserver.desktopmanager.budgie.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.autoLogin.relogin = false;
  services.displayManager.sddm.enableHidpi = true;
  services.displayManager.sddm.settings.EnableAvatars = true;
  services.displayManager.sddm.settings.FacesDir = ./assets/sddm;
  services.displayManager.sddm.settings.ReuseSession = true;
  services.displayManager.sddm.settings.RememberLastSession = true;
  services.displayManager.sddm.settings.RememberLastUser = true;

  home-manager.users.face = {

    programs.waybar.enable = true;
    programs.waybar.style = ./assets/waybar.css;
    programs.waybar.settings = fromJsonFile ./assets/waybar.jsonc;

    services.swaync.enable = true;
    services.swaync.style = ./assets/swaync.css;
    services.swaync.settings = fromJsonFile ./assets/swaync.json;

    services.wl-clip-persist.enable = true;
    # services.wl-clip-persist.systemdTargets = "graphical-session.target";

    xdg.portal.enable = true;
    xdg.portal.config = ''
      [preferred]
      default = hyprland;gtk;kde
      org.freedesktop.impl.portal.FileChooser = kde"
    '';
  };
}
