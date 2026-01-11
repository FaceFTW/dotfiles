{ pkgs, inputs, ... }:
{
  imports = [
    ./hypr.nix
    ./swaync.nix
    ./vicinae.nix
    ./waybar.nix
  ];

  # services.xserver.enable = true;
  # services.xserver.displaymanager.lightdm.enable = true;
  # services.xserver.desktopmanager.budgie.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  fonts.packages = [
    pkgs.nerd-fonts.hack
    pkgs.ubuntu-sans
  ];

  fonts.fontconfig.defaultFonts.monospace = [
    "Hack NF Mono"
    "Ubuntu Mono"
  ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.autoLogin.relogin = false;
  services.displayManager.sddm.enableHidpi = true;
  services.displayManager.sddm.settings.Theme.EnableAvatars = "true";
  services.displayManager.sddm.settings.Theme.FacesDir = "${./assets/sddm}";
  services.displayManager.sddm.settings.Users.ReuseSession = "true";
  services.displayManager.sddm.settings.Users.RememberLastSession = "true";
  services.displayManager.sddm.settings.Users.RememberLastUser = "true";

  qt.enable = true;
  qt.platformTheme = "qt5ct";
  qt.style = "kvantum";

  home-manager.users.face = {
    services.wl-clip-persist.enable = true;

    xdg.portal.config = ''
      [preferred]
      default = hyprland;gtk;kde
      org.freedesktop.impl.portal.FileChooser = kde"
    '';

    home.pointerCursor.enable = true;
    home.pointerCursor.package =
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
    home.pointerCursor.name = "rose-pine-hyprcursor";

    gtk.enable = true;
    gtk.colorScheme = "dark";

    xdg.configFile."Kvantum/kvantum.kvconfig".source = ./assets/Fluent-Dark.kvconfig;
  };

}
