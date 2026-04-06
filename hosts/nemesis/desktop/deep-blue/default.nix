{
  pkgs,
  ...
}:
{
  imports = [
    ../common/ashell.nix
  ];
  #######################################################
  # Hyprland
  #######################################################
  home-manager.users.face.wayland.windowManager.hyprland = {
    settings.general = {
      "col.active_border" = "rgba(3686fdaa)";
      "col.inactive_border" = "rgba(404040aa)";
    };

    settings.group = {
      "col.border_active" = "rgba(3686fdaa)";
      "col.border_inactive" = "rgba(404040aa)";

      groupbar.font_size = 14;
      groupbar.height = 22;
      groupbar.gradients = true;
      groupbar.gradient_rounding = 10;
      groupbar.indicator_height = 0;
      groupbar.text_color = "rgba(ffffffaa)";
      groupbar."col.active" = "rgba(3686fddd)";
      groupbar."col.inactive" = "rgba(404040aa)";
    };

    settings.exec-once = [
      "sleep 1; ${pkgs.ashell}/bin/ashell"
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
        path = "${./deep_blue_invert.png}";
        fit_mode = "contain";
      }
    ];
  };

  #######################################################
  # Hyprlock
  #######################################################
  home-manager.users.face.programs.hyprlock = {
    settings.background = {
      monitor = "";
      path = "${./deep_blue_invert.png}";
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
  # ashell
  #######################################################
  home-manager.users.face.programs.ashell.settings = {
    appearance.primary_color = "#3686fd";
    appearance.background_color = "#2b2b2b";
    appearance.workspace_colors = [ "#3686fd" ];
    appearance.special_workspace_colors = [ "#fd3b3b" ];
  };

  #######################################################
  # silentSDDM
  #######################################################
  programs.silentSDDM = {
    backgrounds.main = ./deep_blue_invert.png;
    settings."LoginScreen".background = "deep_blue_invert.png";
    settings."LockScreen".background = "deep_blue_invert.png";
  };

  #######################################################
  # Limine
  #######################################################
  boot.loader.limine.style.wallpapers = [ ./deep_blue_invert.png ];
}
