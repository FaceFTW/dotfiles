{ ... }:
{
  home-manager.users.face.services.dunst = {
    enable = true;
    settings.global = {
      monitor = 0;
      follow = "none";
      width = "(100, 300)";
      height = "(0, 300)";
      origin = "top-right";
      offset = "(15, 15)";
      scale = 0;
      notification_limit = 10;

      progress_bar = true;
      progress_bar_height = 14;
      progress_bar_frame_width = 0;
      progress_bar_min_width = 100;
      progress_bar_max_width = 300;
      progress_bar_corner_radius = 50;
      progress_bar_corners = "bottom-left, top-right";

      icon_corner_radius = 0;
      icon_corners = "all";
      indicate_hidden = "yes";

      transparency = 0;
      separator_height = 6;
      padding = 10;
      horizontal_padding = 8;
      text_icon_padding = 12;
      frame_width = 1;
      frame_color = "#a0a0a0";
      gap_size = 6;
      separator_color = "frame";
      sort = "yes";

      font = "VCR OSD Mono 12";
      line_height = 0;
      markup = "full";

      # The format of the message.  Possible variables are:
      #   %a  appname
      #   %s  summary
      #   %b  body
      #   %i  iconname (including its path)
      #   %I  iconname (without its path)
      #   %p  progress value if set ([  0%] to [100%]) or nothing
      #   %n  progress value if set without any extra characters
      #   %%  Literal %
      # Markup is allowed
      format = "<b>%s</b>\n%b";
      alignment = "left";
      vertical_alignment = "center";
      show_age_threshold = -1;
      ellipsize = "middle";
      ignore_newline = "no";
      stack_duplicates = true;
      hide_duplicate_count = false;
      show_indicators = "yes";

      ### Icons ###
      enable_recursive_icon_lookup = true;
      icon_theme = "Adwaita, Papirus, Papirus-Dark";
      icon_position = "right";
      min_icon_size = 32;
      max_icon_size = 128;

      # Paths to default icons (only necessary when not using recursive icon lookup)
      icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";

      sticky_history = "yes";
      history_length = 30;

      ### Misc/Advanced ###

      # dmenu path.
      dmenu = "/usr/bin/dmenu -l 10 -p dunst:";
      browser = "/usr/bin/xdg-open";

      always_run_script = true;
      title = "Dunst";
      class = "Dunst";

      corner_radius = 10;
      corners = "bottom, top-left";
      ignore_dbusclose = false;

      force_xwayland = false;
      force_xinerama = false;

      mouse_left_click = "context";
      mouse_middle_click = "do_action, close_current";
      mouse_right_click = "close";
    };

    settings.urgency_low = {
      # IMPORTANT: colors have to be defined in quotation marks.
      # Otherwise the "#" and following would be interpreted as a comment.
      background = "#2c2525";
      foreground = "#e6d9db";
      highlight = "#722ae6, #e4b5cb";
      timeout = 20;
    };

    settings.urgency_normal = {
      background = "#2c2525";
      foreground = "#e6d9db";
      frame_color = "#5e5086";
      highlight = "#722ae6, #e4b5cb";
      timeout = 20;
      override_pause_level = 30;
      # Icon for notifications with normal urgency
      default_icon = "dialog-information";
    };
    settings.urgency_critical = {
      background = "#2c2525";
      foreground = "#e6d9db";
      frame_color = "#d54e53";
      highlight = "#d54e53, #f0f0f0";
      timeout = 0;
      override_pause_level = 60;
      # Icon for notifications with critical urgency
      default_icon = "dialog-warning";
    };
  };
}
