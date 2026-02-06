{ pkgs, inputs, ... }:
{
  imports = [
    ./hypr.nix
    ./swaync.nix
    ./vicinae.nix
    ./waybar.nix
    ./ashell.nix
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

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.autoLogin.relogin = false;
  # services.displayManager.sddm.enableHidpi = true;
  # services.displayManager.sddm.settings.Theme.EnableAvatars = "true";
  # services.displayManager.sddm.settings.Theme.FacesDir = "${./assets/sddm}";
  # services.displayManager.sddm.settings.Users.ReuseSession = "true";
  # services.displayManager.sddm.settings.Users.RememberLastSession = "true";
  # services.displayManager.sddm.settings.Users.RememberLastUser = "true";

  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings.default_input = "login";
  services.displayManager.ly.settings.animation = "colormix";
  services.displayManager.ly.settings.bigclock = "en";
  services.displayManager.ly.settings.colormix_col1 = "0x003686FD";
  services.displayManager.ly.settings.colormix_col2 = "0x00143466";
  services.displayManager.ly.settings.colormix_col3 = "0x20000000";
  services.displayManager.ly.settings.full_color = true;

  qt.enable = true;
  qt.platformTheme = "qt5ct";
  qt.style = "kvantum";

  # File picker for Hyprland
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  programs.dconf.enable = true;
  environment.sessionVariables.GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas/:${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}/glib-2.0/schemas/:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas/";

  home-manager.users.face = {
    services.wl-clip-persist.enable = true;

    home.pointerCursor.enable = true;
    home.pointerCursor.package =
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
    home.pointerCursor.name = "rose-pine-hyprcursor";

    gtk.enable = true;
    gtk.colorScheme = "dark";
    gtk.theme.name = "Fluent-round-Dark-compact";
    gtk.theme.package = pkgs.fluent-gtk-theme.override {
      tweaks = [
        "solid"
        "round"
      ];

      sizeVariants = [
        "standard"
        "compact"
      ];
    };
    gtk.iconTheme.package = pkgs.fluent-icon-theme;
    gtk.iconTheme.name = "Fluent-dark";

    xdg.configFile."Kvantum/KvFluentDark/KvFluentDark.kvconfig".source = ./assets/Fluent-Dark.kvconfig;
    xdg.configFile."Kvantum/KvFluentDark/KvFluentDark.svg".source = ./assets/Fluent-round-solidDark.svg;
    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvFluentDark
    '';

    xdg.terminal-exec.enable = true;
    xdg.terminal-exec.settings.default = [ "alacritty.desktop" ];
  };

}
