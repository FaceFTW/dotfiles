{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  mkFloatRule = class: [
    "match:class ${class}, float on"
    "match:class ${class}, center on"
  ];
in
{
  imports = [ inputs.hyprland.nixosModules.default ];

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
      pkgs.hyprlandPlugins.hyprbars
      # pkgs.hyprlandPlugins.csgo-vulkan-fix
    ];
    systemd.enable = false;

    #######################################################
    # BASIC ALIASES
    #######################################################
    settings."$terminal" = "${pkgs.alacritty}/bin/alacritty";
    settings."$fileManager" = "${pkgs.thunar}/bin/thunar";
    settings."$menu" = "${pkgs.vicinae}/bin/vicinae toggle";
    settings."$browser" =
      "hyprctl dispatch exec \"firefox --ozone-platform=wayland --enable-features=useozoneplatform\"";
    settings."$editor" = "${pkgs.vimCustom}/bin/vim";
    settings."$wallpaper" = "${./assets/deep_blue_invert.png}";
    settings."$cursor" = "rose-pine-hyprcursor";

    settings.monitor = [ "eDP-1,2400x1600@120,0x0,1" ];

    settings.workspace = [
      "1,monitor:eDP-1,persistent:true,default=true"
      "2,monitor:eDP-1,persistent:true"
      "3,monitor:eDP-1,persistent:true"
      "4,monitor:eDP-1,persistent:true"
      "5,monitor:eDP-1,persistent:true"
      "6,monitor:eDP-1,persistent:true"
    ];

    #######################################################
    # AUTOSTART
    #######################################################
    settings.exec-once = [
      "${systemctl} --user start hyprpolkitagent &"
      "${hyprctl} keyword input:kb_numlock true && date \"+%Y-%m-%d %H:%M:%S\" > /tmp/numlock-set"
      "${hyprctl} setcursor $cursor 36"
      "${hyprctl} dispatch workspace 1 &"

      "${pkgs.hyprpaper}/bin/hyprpaper &"
      "${pkgs.swaynotificationcenter}/bin/swaync --config ~/.config/swaync/config.json &"
      "${pkgs.vicinae}/bin/vicinae server &"
      "sleep 1; ${pkgs.ashell}/bin/ashell"

      "sleep 5; $hyprscripts/check_setup_warnings.sh &"

      "${pkgs.bitwarden-desktop}/bin/bitwarden &"
    ];

    #######################################################
    # LOOK AND FEEL
    #######################################################
    settings.general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 3;

      "col.active_border" = "rgba(3686fdaa)";
      "col.inactive_border" = "rgba(404040aa)";
      resize_on_border = true;
      allow_tearing = true;
      layout = "dwindle";

      # Enable Snapping
      "snap:enabled" = true;
      "snap:monitor_gap" = 20;
      "snap:window_gap" = 20;
    };

    settings.group = {
      "col.border_active" = "rgba(3686fdaa)";
      "col.border_inactive" = "rgba(404040aa)";

      groupbar.font_size = 14;
      groupbar.height = 22;
      groupbar.scrolling = false;
      groupbar.gradients = true;
      groupbar.gradient_rounding = 10;
      groupbar.indicator_height = 0;
      groupbar.gaps_in = 10;
      groupbar.gaps_out = 3;
      groupbar.text_color = "rgba(ffffffaa)";
      groupbar."col.active" = "rgba(3686fddd)";
      groupbar."col.inactive" = "rgba(404040aa)";

    };

    settings.decoration = {
      rounding = 5;
      rounding_power = 5;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 0.9;

      shadow.enabled = true;
      shadow.range = 5;
      shadow.render_power = 3;
      shadow.color = " rgba(1a1a1aee)";

      blur.enabled = true;
      blur.size = 3;
      blur.passes = 3;
      blur.xray = true;
      blur.popups = true;
      blur.vibrancy = 0.1696;
    };

    settings.animations.enabled = true;
    settings.animations.bezier = [
      "easeOutQuint,0.23,1,0.32,1"
      "easeInOutCubic,0.65,0.05,0.36,1"
      "linear,0,0,1,1"
      "almostLinear,0.5,0.5,0.75,1.0"
      "quick,0.15,0,0.1,1"
    ];
    settings.animations.animation = [
      "global, 1, 10, default"
      "border, 1, 5.39, easeOutQuint"
      "windows, 1, 4.79, easeOutQuint"
      "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
      "windowsOut, 1, 1.49, linear, popin 87%"
      "fadeIn, 1, 1.73, almostLinear"
      "fadeOut, 1, 1.46, almostLinear"
      "fade, 1, 3.03, quick"
      "layers, 1, 3.81, easeOutQuint"
      "layersIn, 1, 4, easeOutQuint, fade"
      "layersOut, 1, 1.5, linear, fade"
      "fadeLayersIn, 1, 1.79, almostLinear"
      "fadeLayersOut, 1, 1.39, almostLinear"
      "workspaces, 1, 1.5, easeInOutCubic, slide"
      "workspacesIn, 1, 1.21, almostLinear, fade"
      "workspacesOut, 1, 1.94, almostLinear, fade"
    ];

    settings.dwindle.pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    settings.dwindle.preserve_split = true; # You probably want this

    settings.master.new_status = "master";

    settings.misc.vfr = true;
    settings.misc.force_default_wallpaper = 0;
    settings.misc.disable_hyprland_logo = true;
    settings.misc.disable_splash_rendering = true;
    settings.misc.focus_on_activate = true;

    #######################################################
    # PLUGINS
    #######################################################
    settings.plugin.hyprbars = {
      bar_height = 32;

      # (R->L) hyprbars-button = color, size, on-click
      hyprbars-button = [
        " rgb(ff4040), 20, 󰖭, hyprctl dispatch killactive"
        " rgb(eeee11), 20, , hyprctl dispatch fullscreen 1"
      ];

      # cmd to run on double click of the bar
      on_double_click = "hyprctl dispatch fullscreen 1";
    };

    settings.plugin.csgo-vulkan-fix = {
      # Whether to fix the mouse position. A select few apps might be wonky with this.
      fix_mouse = true;

      # Add apps with vkfix-app = initialClass, width, height
      vkfix-app = [ "cs2, 2400, 1600" ];
    };

    #######################################################
    # KEYBINDS
    #######################################################
    settings.bindd = [
      # Open Programms
      "SUPER, SPACE, Open Menu, exec, $menu"
      "SUPER, T, Open Preferred Terminal, exec, $terminal"
      "SUPER, E, Open Preferred File Manager, exec, $fileManager"
      "SUPER, B, Open Preferred Browser, exec, $browser"
      "SUPER, C, Open Preferred Editor, exec, $editor"
      "SUPER, J, Open Preferred Color Picker, exec, $colorPicker"
      "SUPER, $LESS, Open Notification Center, exec, sleep 0.1 && swaync-client -t -sw"

      "SUPER, V, Clipboard History, exec, ${pkgs.vicinae}/bin/vicinae vicinae://extensions/vicinae/clipboard/history"

      # Window Behaivior
      "SUPER, X, Close Active Window, killactive"
      "SUPER, Q, Toggle Fullscreen, fullscreenstate, 3 0"

      "SUPER, B, Toggle Pseudo Layout, pseudo" # dwindle
      "SUPER, N, Toggle Split Layout, togglesplit" # dwindle

      "SUPER ALT, G, Toggle Windowgroup, togglegroup"
      "ALT, TAB, Tab trough Windowgroup, changegroupactive, f"

      "ALT, F4, Force Close Window, signal, 9"

      "SUPER, F, Toggle Window Float, togglefloating, active"

      "SUPER, TAB, Switch Workspace \"Right\", workspace, +1"
      "SUPER SHIFT, TAB, Switch Workspace \"Left\", workspace, -1"
      # "SUPER, up, Move Focus up, movefocus, u"
      # "SUPER, down, Move Focus down, movefocus, d"

      "SUPER SHIFT, S, Take Screenshot, exec, ${pkgs.flameshot}/bin/flameshot gui"

      # Focus Interactions
      "SUPER SHIFT, left, Move Focus left, movefocus, l"
      "SUPER SHIFT, right, Move Focus right, movefocus, r"
      "SUPER SHIFT, up, Move Focus up, movefocus, u"
      "SUPER SHIFT, down, Move Focus down, movefocus, d"

      "SUPER ALT, left, Shrink Window Horizontally, resizeactive, -10 0"
      "SUPER ALT, right, Grow Window Horizontally, resizeactive, 10 0"
      "SUPER ALT, down, Shrink Window Vertically, resizeactive, 0 -10"
      "SUPER ALT, up, Grow Window Vertically, resizeactive, 0 10"

      "SUPER SHIFT ALT, left, Half Window Size Horizontally, resizeactive, 50% 0"
      "SUPER SHIFT ALT, right, Double Window Size Horizontally, resizeactive, 200% 0"
      "SUPER SHIFT ALT, down, Half Window Size Vertically, resizeactive, 0 50%"
      "SUPER SHIFT ALT, up, Double Window Size Vertically, resizeactive, 0 200%"

      # Switch workspaces F[1-10]
      "SUPER , F1, Open Workspace 1, workspace, 1"
      "SUPER , F2, Open Workspace 2, workspace, 2"
      "SUPER , F3, Open Workspace 3, workspace, 3"
      "SUPER , F4, Open Workspace 4, workspace, 4"
      "SUPER , F5, Open Workspace 6, workspace, 5"
      "SUPER , F6, Open Workspace 5, workspace, 6"

      # Move active window to a workspace with SHIFT + F[1-10]
      "SUPER SHIFT, F1, Move to Workspace 1, movetoworkspace, 1"
      "SUPER SHIFT, F2, Move to Workspace 2, movetoworkspace, 2"
      "SUPER SHIFT, F3, Move to Workspace 3, movetoworkspace, 3"
      "SUPER SHIFT, F4, Move to Workspace 4, movetoworkspace, 4"
      "SUPER SHIFT, F5, Move to Workspace 5, movetoworkspace, 5"
      "SUPER SHIFT, F6, Move to Workspace 6, movetoworkspace, 6"
    ];

    settings.bindeld = [
      # Laptop multimedia Interactions and LCD brightness
      ",XF86AudioLowerVolume, Lower Volume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioRaiseVolume, Rise Volume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"

      ",XF86AudioMute, Mute Volume, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, Mute Microphone, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      ",XF86MonBrightnessUp, Turn Up Brightness, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%+"
      ",XF86MonBrightnessDown, Turn Down Brightness, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"
    ];

    # bindmd = $mainMod, mouse:272, Move Window, movewindow
    # bindmd = $mainMod, mouse:273, Resize Window, resizewindow

    # # Screenshots
    # bindd = $mainMod, Y, Take Screenshot of Window, exec, $screenshot window --raw | satty --filename -
    #a bindd = $mainMod, $HOME, Take Screenshot of Monitor, exec, $screenshot output --raw | satty --filename -
    # bindd = , $HOME, Take Screenshot of Region, exec, $screenshot region --raw | satty --filename -

    #######################################################
    # WINDOW RULES
    #######################################################
    settings.windowrule = lib.flatten [
      [
        {
          # Fix some dragging issues with XWayland
          name = "fix-xwayland-drags";
          "match:class" = "^$";
          "match:title" = "^$";
          "match:xwayland" = true;
          "match:float" = true;
          "match:fullscreen" = false;
          "match:pin" = false;

          no_focus = true;
        }
        {
          name = "xwayland-video-bridge-fixes";
          "match:class" = "xwaylandvideobridge";

          no_initial_focus = true;
          no_focus = true;
          no_anim = true;
          no_blur = true;
          max_size = "1 1";
          opacity = 0.0;
        }
      ]

      (mkFloatRule "org.pulseaudio.pavucontrol")
      (mkFloatRule "blueman-manager")
      (mkFloatRule "nm-connection-editor")
      (mkFloatRule "waypaper")
      (mkFloatRule "Tk")
      (mkFloatRule "tuned-gui")
      (mkFloatRule ".blueman-manager-wrapped")
      (mkFloatRule "xdg-desktop-portal-gtk")
      (mkFloatRule "firefox match:title Extension")
      (mkFloatRule "thunar")
      (mkFloatRule "Bitwarden")
      (mkFloatRule "hyprpwcenter")

      "match:class firefox, hyprbars:no_bar on"
      "match:class code, hyprbars:no_bar on"
      "match:class steam, hyprbars:no_bar on"

      "match:class cs2, immediate yes"
    ];

    settings.layerrule = [
      "match:namespace vicinae, blur on"
      "match:namespace vicinae, ignore_alpha 0"
      "match:namespace vicinae, no_anim on"
      "match:namespace swaync-control-center, ignore_alpha 0"
      "match:namespace swaync-control-center, no_anim on"
      "match:namespace swaync-notification-window, ignore_alpha 0"
      "match:namespace swaync-notification-window, no_anim on"
    ];

  };
  #######################################################
  # WALLPAPER
  #######################################################
  home-manager.users.face.services.hyprpaper = {
    enable = true;
    settings.wallpaper = [
      {
        monitor = "eDP-1";
        path = "${./assets/deep_blue_invert.png}";
        fit_mode = "contain";
      }
    ];
  };

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
      path = "${./assets/deep_blue_invert.png}";
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
      outer_color = "rgba(0, 0, 0, 0)";
      inner_color = "rgba(0, 0, 0, 0.2)";
      font_color = "rgba(220,220,220,1)";
      fade_on_empty = false;
      rounding = -1;
      check_color = "rgb(204, 136, 34)";
      placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
      hide_input = false;
      position = "0, -200";
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

    settings.image = {
      monitor = "";
      path = "${./assets/face.png}";
      size = 100;
      border_size = 2;
      border_color = "rgba(242,243,244,0.75)";
      position = "0, -100";
      halign = "center";
      valign = "center";
    };
  };
}
