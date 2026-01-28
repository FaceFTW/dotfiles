{ pkgs, inputs, ... }:
let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
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

  home-manager.users.face = {
    # imports = [ inputs.hyprland.homeManagerModules.default ];

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.package = null;
    wayland.windowManager.hyprland.portalPackage = null;
    wayland.windowManager.hyprland.plugins = [
      pkgs.hyprlandPlugins.hyprbars
      pkgs.hyprlandPlugins.hyprexpo
      # pkgs.hyprlandPlugins.csgo-vulkan-fix
    ];
    wayland.windowManager.hyprland.systemd.enable = false;

    #######################################################
    # BASIC ALIASES
    #######################################################
    wayland.windowManager.hyprland.settings."$terminal" = "${pkgs.alacritty}/bin/alacritty";
    wayland.windowManager.hyprland.settings."$fileManager" = "${pkgs.thunar}/bin/thunar";
    wayland.windowManager.hyprland.settings."$menu" = "${pkgs.vicinae}/bin/vicinae toggle";
    wayland.windowManager.hyprland.settings."$browser" =
      "hyprctl dispatch exec \"firefox --ozone-platform=wayland --enable-features=useozoneplatform\"";
    wayland.windowManager.hyprland.settings."$editor" = "${pkgs.vimCustom}/bin/vim";
    wayland.windowManager.hyprland.settings."$wallpaper" = "${./assets/deep_blue_invert.png}";
    wayland.windowManager.hyprland.settings."$cursor" = "rose-pine-hyprcursor";
    # $screenshot = hyprshot --mode
    # $colorPicker = hyprpicker --autocopy --format hex

    wayland.windowManager.hyprland.settings.monitor = [ "eDP-1,2400x1600@120,0x0,1" ];

    wayland.windowManager.hyprland.settings.workspace = [
      "1,monitor:MONITOR_1"
      "2,monitor:MONITOR_1"
      "3,monitor:MONITOR_1"
      "4,monitor:MONITOR_1"
    ];

    #######################################################
    # AUTOSTART
    #######################################################
    wayland.windowManager.hyprland.settings.exec-once = [
      "${systemctl} --user start hyprpolkitagent &"
      "${hyprctl} keyword input:kb_numlock true && date \"+%Y-%m-%d %H:%M:%S\" > /tmp/numlock-set"
      "${hyprctl} setcursor $cursor 24"

      "${pkgs.swaynotificationcenter}/bin/swaync &"

      "${pkgs.vicinae}/bin/vicinae server &"

      # exec-once = nm-applet --indicator &
      # exec-once = blueman-applet &

      "${pkgs.hyprpaper}/bin/hyprpaper &"

      # exec-once = hypridle &

      # exec-once = ${systemctl} --user start app-org.kde.xwaylandvideobridge@autostart.service &

      "sleep 1; ${pkgs.waybar}/bin/waybar -c \"/home/face/.config/waybar/config\" &"
      "sleep 5; $hyprscripts/check_setup_warnings.sh &"
    ];

    #######################################################
    # LOOK AND FEEL
    #######################################################
    wayland.windowManager.hyprland.settings.general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 3;

      "col.active_border" = "rgba(a591ffdd) rgba(91f8ffaa) 70deg";
      "col.inactive_border" = "rgba(404040aa)";
      resize_on_border = true;
      allow_tearing = true;
      layout = "dwindle";

      # Enable Snapping
      "snap:enabled" = true;
      "snap:monitor_gap" = 20;
      "snap:window_gap" = 20;
    };

    wayland.windowManager.hyprland.settings.group = {
      "col.border_active" = "rgba(a591ffdd) rgba(91f8ffaa) 70deg";
      "col.border_inactive" = "rgba(404040aa)";

      groupbar = {
        font_size = 14;
        height = 22;
        scrolling = false;
        gradients = true;
        gradient_rounding = 10;
        indicator_height = 0;
        gaps_in = 10;
        gaps_out = 3;
        text_color = "rgba(ffffffaa)";
        "col.active" = "rgba(a591ffdd)";
        "col.inactive" = "rgba(404040aa)";
      };

    };

    wayland.windowManager.hyprland.settings.decoration = {
      rounding = 5;
      rounding_power = 5;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 0.9;

      shadow = {
        enabled = true;
        range = 5;
        render_power = 3;
        color = " rgba(1a1a1aee)";
      };

      blur = {
        enabled = true;
        size = 3;
        passes = 3;
        xray = true;
        popups = true;

        vibrancy = 0.1696;
      };
    };

    wayland.windowManager.hyprland.settings.animations.enabled = true;
    wayland.windowManager.hyprland.settings.animations.bezier = [
      "easeOutQuint,0.23,1,0.32,1"
      "easeInOutCubic,0.65,0.05,0.36,1"
      "linear,0,0,1,1"
      "almostLinear,0.5,0.5,0.75,1.0"
      "quick,0.15,0,0.1,1"
    ];
    wayland.windowManager.hyprland.settings.animations.animation = [
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
      "workspaces, 1, 1.94, almostLinear, fade"
      "workspacesIn, 1, 1.21, almostLinear, fade"
      "workspacesOut, 1, 1.94, almostLinear, fade"
    ];

    wayland.windowManager.hyprland.settings.dwindle.pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    wayland.windowManager.hyprland.settings.dwindle.preserve_split = true; # You probably want this

    wayland.windowManager.hyprland.settings.master.new_status = "master";

    wayland.windowManager.hyprland.settings.misc.vfr = true;
    wayland.windowManager.hyprland.settings.misc.force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
    wayland.windowManager.hyprland.settings.misc.disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
    wayland.windowManager.hyprland.settings.misc.focus_on_activate = true;

    #######################################################
    # PLUGINS
    #######################################################
    wayland.windowManager.hyprland.settings.plugin.hyprbars = {
      bar_height = 20;

      # (R->L) hyprbars-button = color, size, on-click
      hyprbars-button = [
        " rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
        " rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
      ];

      # cmd to run on double click of the bar
      on_double_click = "hyprctl dispatch fullscreen 1";
    };

    wayland.windowManager.hyprland.settings.plugin.csgo-vulkan-fix = {
      # Whether to fix the mouse position. A select few apps might be wonky with this.
      fix_mouse = true;

      # Add apps with vkfix-app = initialClass, width, height
      vkfix-app = [ "cs2, 2400, 1600" ];
    };

    wayland.windowManager.hyprland.settings.plugin.hyprexpo = {
      columns = 4;
      gap_size = 25;
      workspace_method = "first current";
      skip_empty = true;
    };

    #######################################################
    # KEYBINDS
    #######################################################
    wayland.windowManager.hyprland.settings.bindd = [
      # Open Programms
      "SUPER, SPACE, Open Menu, exec, $menu"
      "SUPER, T, Open Preferred Terminal, exec, $terminal"
      "SUPER, E, Open Preferred File Manager, exec, $fileManager"
      "SUPER, F, Open Preferred Browser, exec, $browser"
      "SUPER, C, Open Preferred Editor, exec, $editor"
      "SUPER, J, Open Preferred Color Picker, exec, $colorPicker"
      "SUPER, $LESS, Open Notification Center, exec, sleep 0.1 && swaync-client -t -sw"

      "SUPER, V, Clipboard History, exec, ${pkgs.vicinae}/bin/vicinae vicinae://extensions/vicinae/clipboard/history"

      "SUPER, TAB, Workspace View, hyprexpo:expo, toggle"

      # Window Behaivior
      "SUPER, X, Close Active Window, killactive"
      "SUPER, Q, Toggle Fullscreen, fullscreenstate, 3 0"

      "SUPER, B, Toggle Pseudo Layout, pseudo" # dwindle
      "SUPER, N, Toggle Split Layout, togglesplit" # dwindle

      "SUPER ALT, G, Toggle Windowgroup, togglegroup"
      "ALT, TAB, Tab trough Windowgroup, changegroupactive, f"

      "ALT, F4, Force Close Window, signal, 9"

      "SUPER SHIFT, F, Toggle Window Float, togglefloating, active"

      "SUPER ALT, left, Shrink Window Horizontally, resizeactive, -10 0"
      "SUPER ALT, right, Grow Window Horizontally, resizeactive, 10 0"
      "SUPER ALT, down, Shrink Window Vertically, resizeactive, 0 -10"
      "SUPER ALT, up, Grow Window Vertically, resizeactive, 0 10"

      "SUPER SHIFT ALT, left, Half Window Size Horizontally, resizeactive, 50% 0"
      "SUPER SHIFT ALT, right, Double Window Size Horizontally, resizeactive, 200% 0"
      "SUPER SHIFT ALT, down, Half Window Size Vertically, resizeactive, 0 50%"
      "SUPER SHIFT ALT, up, Double Window Size Vertically, resizeactive, 0 200%"

      # System Interactions
      "SUPER, L, Lock Screen, exec, hyprlock"
      "SUPER, M, Exit Hyprland, exit,"
      "SUPER, O, Reboot PC, exec, reboot"
      "SUPER, P, Shutdown PC, exec, poweroff"

      # Focus Interactions
      "SUPER, left, Move Focus left, movefocus, l"
      "SUPER, right, Move Focus right, movefocus, r"
      "SUPER, up, Move Focus up, movefocus, u"
      "SUPER, down, Move Focus down, movefocus, d"

      # Switch workspaces F[1-10]
      "SUPER , F1, Open Workspace 1, workspace, 1"
      "SUPER , F2, Open Workspace 2, workspace, 2"
      "SUPER , F3, Open Workspace 3, workspace, 3"
      "SUPER , F4, Open Workspace 4, workspace, 4"

      # Move active window to a workspace with SHIFT + F[1-10]
      "SUPER SHIFT, F1, Move to Workspace 1, movetoworkspace, 1"
      "SUPER SHIFT, F2, Move to Workspace 2, movetoworkspace, 2"
      "SUPER SHIFT, F3, Move to Workspace 3, movetoworkspace, 3"
      "SUPER SHIFT, F4, Move to Workspace 4, movetoworkspace, 4"
    ];

    wayland.windowManager.hyprland.settings.bindeld = [
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

    # Scroll through existing workspaces with mainMod + scroll
    # bindd = $mainMod, mouse_down, Go to Next Workspace, workspace, e+1
    # bindd = $mainMod, mouse_up, Go to Last Workspace, workspace, e-1

    #######################################################
    # WINDOW RULES
    #######################################################
    wayland.windowManager.hyprland.extraConfig = ''
      # Ignore maximize requests from apps. You'll probably like this.
      # windowrule = suppressevent maximize, class:.*

      windowrule {
        # Fix some dragging issues with XWayland
        name = fix-xwayland-drags
        match:class = ^$
        match:title = ^$
        match:xwayland = true
        match:float = true
        match:fullscreen = false
        match:pin = false

        no_focus = true
      }

      windowrule {
          name = xwayland-video-bridge-fixes
          match:class = xwaylandvideobridge

          no_initial_focus = true
          no_focus = true
          no_anim = true
          no_blur = true
          max_size = 1 1
          opacity = 0.0
      }

      windowrule = match:class org.pulseaudio.pavucontrol, float on
      windowrule = match:class org.pulseaudio.pavucontrol, center on

      windowrule = match:class blueman-manager, float on
      windowrule = match:class blueman-manager, center on

      windowrule = match:class nm-connection-editor, float on
      windowrule = match:class nm-connection-editor, center on

      windowrule = match:class waypaper, float on
      windowrule = match:class waypaper, center on

      windowrule = match:class Tk, float on
      windowrule = match:class Tk, center on

      windowrule = match:class tuned-gui, float on
      windowrule = match:class tuned-gui, center on

      windowrule = match:class thunar, float on
      windowrule = match:class thunar, center on

      windowrule = match:class firefox, hyprbars:no_bar on


      windowrule = match:class steam, hyprbars:no_bar on
      windowrule = match:class steam match:initialTitle: Settings, float on
      windowrule = match:class cs2, immediate yes

      layerrule = match:namespace vicinae, blur on
      layerrule = match:namespace vicinae, ignore_alpha 0
      layerrule = match:namespace vicinae, no_anim on
    '';

    #######################################################
    # WALLPAPER
    #######################################################
    services.hyprpaper.enable = true;
    services.hyprpaper.settings.wallpaper = [
      {
        monitor = "eDP-1";
        path = "${./assets/deep_blue_invert.png}";
        fit_mode = "contain";
      }
    ];

  };
}
