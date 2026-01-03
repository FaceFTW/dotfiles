{ ... }:
{
  imports = [
    ./hypr.nix
    ./swaync.nix
    ./waybar.nix
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
  services.displayManager.sddm.settings.Theme.EnableAvatars = "true";
  services.displayManager.sddm.settings.Theme.FacesDir = "${./assets/sddm}";
  services.displayManager.sddm.settings.Users.ReuseSession = "true";
  services.displayManager.sddm.settings.Users.RememberLastSession = "true";
  services.displayManager.sddm.settings.Users.RememberLastUser = "true";

  home-manager.users.face = {
    services.wl-clip-persist.enable = true;
    # services.wl-clip-persist.systemdTargets = "graphical-session.target";

    # xdg.portal.enable = true;
    xdg.portal.config = ''
      [preferred]
      default = hyprland;gtk;kde
      org.freedesktop.impl.portal.FileChooser = kde"
    '';
  };
}
