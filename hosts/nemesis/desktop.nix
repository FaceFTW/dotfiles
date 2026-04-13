{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # ./desktop/common/ashell.nix
    ./desktop/common/flameshot.nix
    ./desktop/common/frameworks.nix
    ./desktop/common/hypr.nix
    # ./desktop/common/ly.nix
    ./desktop/common/silentsddm.nix
    ./desktop/common/swaync.nix
    ./desktop/common/vicinae.nix
    # THEMES
    # ./themes/deep-blue
    ./desktop/fraud
  ];

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  fonts.packages = [
    pkgs.nerd-fonts.hack
    pkgs.ubuntu-sans
    pkgs.vcr-osd-mono-font
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
