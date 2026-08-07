{
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

  environment.sessionVariables.AQ_DRM_DEVICES = "/dev/dri/intel_gpu:/dev/dri/nvidia_gpu";

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
        "XXX_START_HYPRPOLKITAGENT_XXX"
        "${systemctl} --user start hyprpolkitagent &"
      ]
      [
        "XXX_START_HYPRCTL_NUMLOCK_XXX"
        "${hyprctl} keyword input:kb_numlock true && date '+%Y-%m-%d %H:%M:%S' > /tmp/numlock-set"
      ]
      [
        "XXX_START_HYPRCTL_SETCURSOR_XXX"
        "${hyprctl} setcursor rose-pine-hyprcursor 36"
      ]
      [
        "XXX_START_HYPRCTL_DISPATCH_XXX"
        "${hyprctl} dispatch workspace 1 &"
      ]
      [
        "XXX_START_HYPRPAPER_XXX"
        "${pkgs.hyprpaper}/bin/hyprpaper &"
      ]
      [
        "XXX_START_VICINAE_XXX"
        "${pkgs.vicinae}/bin/vicinae server &"
      ]
      # [
      #   "XXX_START_BITWARDEN_DESKTOP_XXX"
      #   "${pkgs.bitwarden-desktop}/bin/bitwarden &"
      # ]
      [
        "--- XXX_EXTRA_STARTUP_XXX"
        ''
          hl.exec_cmd("sleep 1; ${pkgs.fraudshell}/bin/fraudshell &")
          hl.exec_cmd("sleep 10; ${systemctl} --user start syncthing")
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

  #######################################################
  # LOCK SCREEN
  #######################################################
  home-manager.users.face.programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;

    settings.general = {
      no_fade_in = true;
      no_fade_out = true;
      hide_cursor = false;
      grace = 0;
      disable_loading_bar = true;
    };

    settings.background = {
      monitor = "";
      path = "${./wallpapers/fraud-3-wallpaper.png}";
      blur_passes = 2;
      contrast = 1;
      brightness = 0.5;
      vibrancy = 0.2;
      vibrancy_darkness = 0.2;
    };

    settings.input-field = {
      monitor = "";
      size = "250, 60";
      outline_thickness = 2;
      dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true;
      fade_on_empty = false;
      rounding = -1;
      hide_input = false;
      position = "0, -200";
      halign = "center";
      valign = "center";
      outer_color = "rgba(0, 0, 0, 0)";
      inner_color = "rgba(0, 0, 0, 0.2)";
      font_color = "rgba(220,220,220,1)";
      check_color = "rgb(204, 136, 34)";
      placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
    };

    settings.image = {
      monitor = "";
      path = "${./face.png}";
      size = 100;
      border_size = 2;
      border_color = "rgba(242,243,244,0.75)";
      position = "0, -100";
      halign = "center";
      valign = "center";
    };

    settings.label = [
      # DATE
      {
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 22;
        font_family = "Hack Mono Bold";
        position = "0, 300";
        halign = "center";
        valign = "center";
      }

      # TIME
      {
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +"%-I:%M")"'';
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 95;
        font_family = "Hack Mono Bold";
        position = "0, 200";
        halign = "center";
        valign = "center";
      }
    ];
  };

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
  };
}
