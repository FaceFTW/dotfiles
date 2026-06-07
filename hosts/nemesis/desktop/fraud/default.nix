{
  pkgs,
  lib,
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
  imports = [
    ./waybar.nix
    ./dunst.nix
  ];

  #######################################################
  # Hyprland
  #######################################################
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
          hl.exec_cmd("sleep 1; ${pkgs.waybar}/bin/waybar &")
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

    ] (unsafeDiscardStringContext (readFile ../common/hyprland.lua));

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

  #######################################################
  # Hyprlock
  #######################################################
  home-manager.users.face.programs.hyprlock = {
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
      outer_color = "rgba(0, 0, 0, 0)";
      inner_color = "rgba(0, 0, 0, 0.2)";
      font_color = "rgba(220,220,220,1)";
      check_color = "rgb(204, 136, 34)";
      placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
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
  # silentSDDM
  #######################################################
  programs.silentSDDM = {
    backgrounds.main = ./wallpapers/fraud-3-wallpaper.png;
    settings."LoginScreen".background = "fraud-3-wallpaper.png";
    settings."LockScreen".background = "fraud-3-wallpaper.png";
    settings."LoginScreen".blur = 75;

  };

  #######################################################
  # Limine
  #######################################################
  boot.loader.limine.style.wallpapers = [
    ./wallpapers/fraud-1-wallpaper.png
    ./wallpapers/fraud-2-wallpaper.png
    ./wallpapers/fraud-3-wallpaper.png
  ];
  boot.loader.limine.style.interface.branding = "ENTERING LAYER 8 - FRAUD";
}
