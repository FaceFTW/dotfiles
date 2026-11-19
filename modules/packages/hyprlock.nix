{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.packages.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock (User Install Only)";
    wallpaper = lib.mkOption {
      type = with lib.types; path;
    };
    userIcon = lib.mkOption {
      type = with lib.types; path;
    };
  };

  config = lib.mkIf config.modules.packages.hyprlock.enable {
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
        path = "${config.modules.packages.hyprlock.wallpaper}";
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
        path = "${config.modules.packages.hyprlock.userIcon}";
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
  };

}
