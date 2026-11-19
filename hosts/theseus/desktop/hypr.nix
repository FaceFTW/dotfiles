{
  config,
  lib,
  pkgs,
  ...
}:
let
  replaceByPairs =
    with lib;
    xs: str:
    let
      keys = map (x: elemAt x 0) xs;
      vals = map (x: elemAt x 1) xs;
    in
    replaceStrings keys vals str;
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{
  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;
  programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

  systemd.user.services.hyprpolkitagent = {
    serviceConfig.ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
  };

  #######################################################
  # Hyprland
  #######################################################
  home-manager.users.face.wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    plugins = [
      # pkgs.hyprlandPlugins.hyprbars
      # pkgs.hyprlandPlugins.csgo-vulkan-fix
    ];
    systemd.enable = false;

    # Config is set per theme
    configType = "lua";
  };

  home-manager.users.face.home.file.".config/hypr/hyprland.lua".text =
    with lib;
    replaceByPairs [
      [
        "XXX_ALACRITTY_XXX"
        "${pkgs.alacritty}/bin/alacritty"
      ]
      [
        "XXX_THUNAR_XXX"
        "${pkgs.thunar}/bin/thunar"
      ]
      [
        "XXX_VICINAE_XXX"
        "${pkgs.vicinae}/bin/vicinae toggle"
      ]
      [
        "XXX_CLIPBOARD_HIST_XXX"
        "${pkgs.thunar}/bin/thunar"
      ]
      [
        "XXX_FIREFOX_XXX"
        "$firefox --ozone-platform=wayland --enable-features=useozoneplatform"
      ]
      [
        "XXX_ZED_XXX"
        "${pkgs.zed-editor}/bin/zeditor"
      ]
      [
        "XXX_SCREENSHOT_XXX"
        "${pkgs.flameshot}/bin/flameshot gui"
      ]
      [
        "XXX_WIREPLUMBER_XXX"
        "${pkgs.wireplumber}/bin/wpctl"
      ]
      [
        "XXX_BRIGHTNESSCTL_XXX"
        "${pkgs.brightnessctl}/bin/brightnessctl"
      ]
      [
        "XXX_HYPRLOCK_XXX"
        "${pkgs.hyprlock}/bin/hyprlock"
      ]
      [
        "--- XXX_EXTRA_STARTUP_XXX"
        # lua
        ''
          --- Background Nitty Gritty
          hl.exec_cmd("${systemctl} --user start hyprpolkitagent &")
          hl.exec_cmd("${hyprctl} keyword input:kb_numlock true && date '+%Y-%m-%d %H:%M:%S' > /tmp/numlock-set")
          hl.exec_cmd("${hyprctl} setcursor rose-pine-hyprcursor 36")
          hl.exec_cmd("${hyprctl} dispatch workspace 1 &")
          hl.exec_cmd("${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets &")

          --- Core Shell Experience
          hl.exec_cmd("${pkgs.hyprpaper}/bin/hyprpaper &")
          hl.exec_cmd("sleep 1; ${pkgs.quickshell}/bin/quickshell -p /home/face/.config/quickshell/fraudshell &")
          hl.exec_cmd("${pkgs.vicinae}/bin/vicinae server &")

          --- User Autostart Apps
          hl.exec_cmd("sleep 10; ${systemctl} --user start syncthing")
          hl.exec_cmd("sleep 10; ${pkgs.keepassxc}/bin/keepassxc &")
        ''
      ]
      # TODO probably a hypr bug
      #
      [
        "\"XXX_COL_ACTIVE_BORDER_XXX\""
        "\"rgba(fa6982aa)\", \"rgba(fafa00aa)\", \"rgba(96f06eaa)\", \"rgba(6ec8faaa)\", \"rgba(dc6ea5aa)\""
      ]
      [
        "XXX_COL_INACTIVE_BORDER_XXX"
        "rgba(404040aa)"
      ]
      [
        "XXX_GROUPBAR_TEXT_COLOR_XXX"
        "rgba(ffffffaa)"
      ]

    ] (unsafeDiscardStringContext (readFile ./hyprland.lua));

  home-manager.users.face.home.activation = {
    hyprland-meta-link = config.home-manager.users.face.lib.dag.entryAfter [ "writeBoundary" ] ''
      run ln -sf $VERBOSE_ARG ${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua /home/face/.local/hl.meta.lua
    '';
  };

  #######################################################
  # LOCK SCREEN
  #######################################################

  #######################################################
  # Hyprpaper
  #######################################################
  home-manager.users.face.services.hyprpaper = {
    enable = true;
    settings.wallpaper = [
      {
        monitor = "eDP-1";
        path = "${./wallpapers}";
        fit_mode = "contain";
        timeout = 300;
      }
    ];
    settings.splash = false;
  };
}
