{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./dunst.nix
    ./flameshot.nix
    ./frameworks.nix
    ./hypr.nix
    ./vicinae.nix
  ];

  #######################################################
  # Limine
  #######################################################
  boot.loader.limine.style.wallpapers = [
    ./wallpapers/fraud-1-wallpaper.png
    ./wallpapers/fraud-2-wallpaper.png
    ./wallpapers/fraud-3-wallpaper.png
  ];
  boot.loader.limine.style.interface.branding = "ENTERING LAYER 8 - FRAUD";

  #######################################################
  # Ly
  #######################################################
  services.displayManager.ly = {
    enable = true;
    settings.default_input = "login";
    settings.animation = "colormix";
    settings.bigclock = "en";
    settings.colormix_col1 = "0x003686FD";
    settings.colormix_col2 = "0x00143466";
    settings.colormix_col3 = "0x20000000";
    settings.full_color = true;
  };

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  fonts.packages = [
    pkgs.nerd-fonts.hack
    pkgs.ubuntu-sans
    pkgs.vcr-osd-mono-font
    pkgs.noto-fonts-color-emoji
    pkgs.lucide
  ];
  fonts.fontconfig.defaultFonts.monospace = [
    "Hack NF Mono"
    "Ubuntu Mono"
  ];

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

    xdg.terminal-exec.enable = true;
    xdg.terminal-exec.settings.default = [ "alacritty.desktop" ];
  };
}
