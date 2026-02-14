{ pkgs, inputs, ... }:

{
  imports = [
    ./hypr.nix
    ./swaync.nix
    ./vicinae.nix
    ./ashell.nix
  ];

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

  # This replace SDDM configuration
  services.displayManager.defaultSession = "hyprland";
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds.main = ./assets/deep_blue_invert.png;
    profileIcons.face = ./assets/face.png;
    settings."LoginScreen".background = "deep_blue_invert.png";
    settings."LockScreen".background = "deep_blue_invert.png";
    settings."LoginScreen.LoginArea.Avatar".shape = "circle";
  };

  # services.displayManager.ly = {
  #   enable = true;
  #   settings.default_input = "login";
  #   settings.animation = "colormix";
  #   settings.bigclock = "en";
  #   settings.colormix_col1 = "0x003686FD";
  #   settings.colormix_col2 = "0x00143466";
  #   settings.colormix_col3 = "0x20000000";
  #   settings.full_color = true;
  # };

  # services.xserver.displayManager.lightdm = {
  #   greeter.
  #   enable = true;
  #   greeters.slick.enable = true;
  #   greeters.slick.iconTheme.name = "Fluent-dark";
  #   greeters.slick.iconTheme.package = pkgs.fluent-icon-theme;
  #   greeters.slick.theme.name = "Fluent-round-Dark-compact";
  #   greeters.slick.theme.package = pkgs.fluent-gtk-theme;
  #   greeters.slick.extraConfig = ''
  #     [Greeter]
  #     show-hostname=true
  #     show-power=true
  #     show-clock=true
  #     show-quit=true
  #     background=${./assets/deep_blue_invert.png}
  #   '';
  # };

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
    gtk.theme.package = pkgs.fluent-gtk-theme;
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
