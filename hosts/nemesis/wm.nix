{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.autoLogin.relogin = false;
  services.displayManager.sddm.enableHidpi = true;
  services.displayManager.sddm.settings.EnableAvatars = true;

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  programs.hyprland.portalPackage =
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  programs.hyprland.systemd.setPath.enable = true;
  # programs.hyprland.withUWSM = true;

  programs.hyprlock.enable = true;

  home-manager.users.face = {

    programs.waybar.enable = true;
    programs.waybar.style = ./assets/waybar.css;

    services.swaync.enable = true;
    # services.swaync.settings = builtins.re;


    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.package = null;
    wayland.windowManager.hyprland.portalPackage = null;
    wayland.windowManager.hyprland.plugins = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    ];
    wayland.windowManager.hyprland.extraConfig = ''
      $terminal = alacritty
      $fileManager = thunar
      $menu = wofi --show drun --style ~/.config/wofi/menu.css
      $browser = hyprctl dispatch exec "firefox --ozone-platform=wayland --enable-features=UseOzonePlatform"
      $editor = vim
      $wallpaper=~/Hyprland-Simple-Setup/Wallpaper/Forest_01.png

      # $screenshot = hyprshot --mode
      # $cursor = rose-pine-hyprcursor
      # $colorPicker = hyprpicker --autocopy --format hex
      # $git = github-desktop
      # $calc = qalculate-gtk
      # $hyprscripts = ~/.config/hypr/scripts
      # $calendar = ~/.config/hypr/scripts/float_calendar.sh

      #######################################################
      # AUTOSTART
      #######################################################
      # Start Polkit Agent for Authentication
      exec-once = systemctl --user start hyprpolkitagent &
      exec-once = hyprctl keyword input:kb_numlock true && date "+%Y-%m-%d %H:%M:%S" > /tmp/numlock-set
      exec-once = /usr/lib/polkit-kde-authentication-agent-1 &

      exec-once = swaync

      exec-once = nm-applet --indicator &
      exec-once = blueman-applet &

      exec-once = hyprpaper &
      exec-once = $hyprscripts/change_wallpaper.sh &

      exec-once = wl-clip-persist --clipboard regular &
      exec-once = wl-clipboard-history -t &

      # Start Idle Manager
      exec-once = hypridle &

      exec-once = systemctl --user start app-org.kde.xwaylandvideobridge@autostart.service &

      # Fix Dolphin File Manager
      exec-once = $hyprscripts/fix-dolphin.sh &

      # Cursor theme
      exec-once = hyprctl setcursor $cursor 24

      exec-once = hyprsunset

      # exec-once = sleep 1; waybar -c "$HOME/.config/waybar/config.jsonc" &
      # exec-once = $hyprscripts/Startup_check.sh &
      exec-once = sleep 5; $hyprscripts/check_setup_warnings.sh &

      #######################################################
      # LOOK AND FEEL
      #######################################################
      general {
          gaps_in = 5
          gaps_out = 5

          border_size = 3

          col.active_border = rgba(a591ffdd) rgba(91f8ffaa) 70deg
          col.inactive_border = rgba(404040aa)

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true

          allow_tearing = false

          layout = dwindle

          # Enable Snapping
          snap:enabled = true
          snap:monitor_gap = 20
          snap:window_gap = 20
      }

      group {
          col.border_active = rgba(a591ffdd) rgba(91f8ffaa) 70deg
          col.border_inactive = rgba(404040aa)

          groupbar {
              font_size = 14
              height = 22
              scrolling = false
              gradients = true
              gradient_rounding = 10
              indicator_height = 0
              gaps_in = 10
              gaps_out = 3
              text_color = rgba(ffffffaa)
              col.active = rgba(a591ffdd)
              col.inactive = rgba(404040aa)
          }
      }

      decoration {
          rounding = 5
          rounding_power = 5

          # Change transparency of focused and unfocused windows
          active_opacity = 0.9
          inactive_opacity = 0.9

          shadow {
              enabled = true
              range = 5
              render_power = 3
              color = rgba(1a1a1aee)
          }

          blur {
              enabled = true
              size = 3
              passes = 3
              xray = true
              popups = true

              vibrancy = 0.1696
          }
      }

      animations {
          enabled = true

          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, almostLinear, fade
          animation = workspacesIn, 1, 1.21, almostLinear, fade
          animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      master {
          new_status = master
      }

      misc {
          vfr = true # Enable VFR (Variable Frame Rate) for Hyprland
          force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
      }

      #######################################################
      # PLUGINS
      #######################################################
      plugin {
          hyprbars {
              # example config
              bar_height = 20

              # example buttons (R -> L)
              # hyprbars-button = color, size, on-click
              hyprbars-button = rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive
              hyprbars-button = rgb(eeee11), 10, , hyprctl dispatch fullscreen 1

              # cmd to run on double click of the bar
              on_double_click = hyprctl dispatch fullscreen 1
          }
      }
      #######################################################
      # KEYBINDS
      #######################################################
      $mainMod = SUPER # Sets "Windows" key as 1. main modifier
      $mainMod1 = CTRL # Sets "Control" key as 2. main modifier
      $mainMod2 = SHIFT # Sets "Shift" key as 3. main modifier
      $mainMod3 = ALT # Sets "alt" key as 4. main modifier

      $ENTER = code:104 # NUMLOCK Enter key
      $PLUS = code:88 # NUMLOCK Plus key
      $MINUS = code:82 # NUMLOCK Minus Key
      $MULTIPLY = code:63 # NUMLOCK Multiply Key
      $DIVISION = code:106 # NUMLOCK Division Key
      $LESS = code:94 # Less Key

      $DOUBLES = code:49 # "§" Key
      $HOME = code:110 # Home Key

      # Open Programms
      bindd = $mainMod, SPACE, Open Menu, exec, pkill wofi || $menu
      bindd = $mainMod1, Y, Open Preferred Terminal, exec, $terminal
      bindd = $mainMod, E, Open Preferred File Manager, exec, $fileManager
      bindd = $mainMod, F, Open Preferred Browser, exec, $browser
      bindd = $mainMod, C, Open Preferred Editor, exec, $editor
      bindd = $mainMod, J, Open Preferred Color Picker, exec, $colorPicker
      bindd = $mainMod, K, Open Preferred Calendar, exec, $calendar
      bindd = $mainMod, $ENTER, Open Calculator, exec, $calc
      bindd = $mainMod, $LESS, Open Notification Center, exec, sleep 0.1 && swaync-client -t -sw
      bindd = $mainMod $mainMod2, W, Open Archwiki (Locally), exec, vivaldi /usr/share/doc/arch-wiki/html/en/Table_of_contents.html

      # Window Behaivior
      bindd = $mainMod, X, Close Active Window, killactive,
      bindd = $mainMod, Q, Toggle Fullscreen, fullscreenstate, 3 0

      bindd = $mainMod, B, Toggle Pseudo Layout, pseudo, # dwindle
      bindd = $mainMod, N, Toggle Split Layout, togglesplit, # dwindle

      bindd = $mainMod $mainMod1, G, Toggle Windowgroup, togglegroup
      bindd = $mainMod3, tab, Tab trough Windowgroup, changegroupactive, f

      bindd = $mainMod, S, Toggle Special Workspace (Minimize), togglespecialworkspace, magic
      bind = $mainMod, S, movetoworkspace, +0
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod, S, movetoworkspace, special:magic
      bind = $mainMod, S, togglespecialworkspace, magic

      bindmd = $mainMod, mouse:272, Move Window, movewindow
      bindmd = $mainMod, mouse:273, Resize Window, resizewindow

      bindd = $mainMod $mainMod1, X, Toggle Scratchpad Terminal, exec, pypr toggle term

      # Screenshots
      bindd = $mainMod, Y, Take Screenshot of Window, exec, $screenshot window --raw | satty --filename -
      bindd = $mainMod, $HOME, Take Screenshot of Monitor, exec, $screenshot output --raw | satty --filename -
      bindd = , $HOME, Take Screenshot of Region, exec, $screenshot region --raw | satty --filename -

      # Wallpaper Interactions
      bindd = $mainMod $mainMod1, W, Set Wallpaper, exec, waypaper
      bindd = $mainMod, H, Toggle Waybar, exec, $hyprscripts/toggle_waybar.sh

      # Custom Hyprscript Keybindings
      bindd = $mainMod, V, Toggle Floating, exec, $hyprscripts/toggle_floating.sh
      bindd = $mainMod, W, Change Wallpaper, exec, $hyprscripts/change_wallpaper.sh
      bindd = $mainMod $mainMod1, S, Start Hyprsunset, exec, $hyprscripts/hyprsunset.sh
      bindd = $mainMod $mainMod1, M, Start Music Player, exec, hyprctl dispatch exec "[workspace 7 silent] kitty -e $hyprscripts/play_music.sh"
      bindd = $mainMod, $DOUBLES, Open Notes, exec, $hyprscripts/notes.sh
      bindd = $mainMod $mainMod2, B, Turn Bluetooth ON or OFF, exec, $hyprscripts/toggle_bluetooth.sh

      # System Interactions
      bindd = $mainMod, L, Lock Screen, exec, hyprlock
      bindd = $mainMod, M, Exit Hyprland, exit,
      bindd = $mainMod, O, Reboot PC, exec, reboot
      bindd = $mainMod, P, Shutdown PC, exec, poweroff

      # Focus Interactions
      bindd = $mainMod, left, Move Focus left, movefocus, l
      bindd = $mainMod, right, Move Focus right, movefocus, r
      bindd = $mainMod, up, Move Focus up, movefocus, u
      bindd = $mainMod, down, Move Focus down, movefocus, d

      # Temporarly disable Global shortcuts
      bindd = $mainMod $mainMod1, L, Disable Global Hyprland Keybinds (if enabled), submap, clean
      submap = clean
      bindd = $mainMod $mainMod1, L, Enable Global Hyprland Keybinds (if disabled), submap, reset
      submap = reset

      # Switch workspaces F[1-10]
      # bindd =  , F1, Open Workspace 1, workspace, 1
      # bindd =  , F2, Open Workspace 2, workspace, 2
      # bindd =  , F3, Open Workspace 3, workspace, 3
      # bindd =  , F4, Open Workspace 4, workspace, 4
      # bindd =  , F5, Open Workspace 5, workspace, 5
      # bindd =  , F6, Open Workspace 6, workspace, 6
      # bindd =  , F7, Open Workspace 7, workspace, 7
      # bindd =  , F8, Open Workspace 8, workspace, 8
      # bindd =  , F9, Open Workspace 9, workspace, 9
      # bindd =  , F10, Open Workspace 10, workspace, 10

      # # Move active window to a workspace with SHIFT + F[1-10]
      # bindd = $mainMod2, F1, Move to Workspace 1, movetoworkspace, 1
      # bindd = $mainMod2, F2, Move to Workspace 2, movetoworkspace, 2
      # bindd = $mainMod2, F3, Move to Workspace 3, movetoworkspace, 3
      # bindd = $mainMod2, F4, Move to Workspace 4, movetoworkspace, 4
      # bindd = $mainMod2, F5, Move to Workspace 5, movetoworkspace, 5
      # bindd = $mainMod2, F6, Move to Workspace 6, movetoworkspace, 6
      # bindd = $mainMod2, F7, Move to Workspace 7, movetoworkspace, 7
      # bindd = $mainMod2, F8, Move to Workspace 8, movetoworkspace, 8
      # bindd = $mainMod2, F9, Move to Workspace 9, movetoworkspace, 9
      # bindd = $mainMod2, F10, Move to Workspace 10, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      # bindd = $mainMod, mouse_down, Go to Next Workspace, workspace, e+1
      # bindd = $mainMod, mouse_up, Go to Last Workspace, workspace, e-1

      # Laptop multimedia Interactions and LCD brightness
      bindeld = ,XF86AudioLowerVolume, Lower Volume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindeld = ,XF86AudioRaiseVolume, Rise Volume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

      bindeld = ,XF86AudioMute, Mute Volume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindeld = ,XF86AudioMicMute, Mute Microphone, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      bindeld = ,XF86MonBrightnessUp, Turn Up Brightness, exec, brightnessctl s 10%+
      bindeld = ,XF86MonBrightnessDown, Turn Down Brightness, exec, brightnessctl s 10%-

      #######################################################
      # WINDOW RULES
      #######################################################
      # Workspace 1
      windowrule = workspace 1 silent, class:code, title:Visual Studio Code

      # Workspace 2
      windowrule = workspace 2 silent, class:vivaldi-stable

      # Ignore maximize requests from apps. You'll probably like this.
      windowrule = suppressevent maximize, class:.*

      # Fix some dragging issues with XWayland
      windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

      # XWayland video bridge window rules
      windowrule = opacity 0.0 override, class:xwaylandvideobridge
      windowrule = noanim, class:xwaylandvideobridge
      windowrule = noinitialfocus, class:xwaylandvideobridge
      windowrule = maxsize 1 1, class:xwaylandvideobridge
      windowrule = noblur, class:xwaylandvideobridge
      windowrule = nofocus, class:xwaylandvideobridge
      windowrule = workspace 1, class:xwaylandvideobridge

      windowrule = float,class:org.pulseaudio.pavucontrol
      windowrule = center,class:org.pulseaudio.pavucontrol

      windowrule = float, class:blueman-manager
      windowrule = center, class:blueman-manager

      windowrule = float, class:nm-connection-editor
      windowrule = center, class:nm-connection-editor

      windowrule = float, class:waypaper
      windowrule = center, class:waypaper

      windowrule = float, class:Tk
      windowrule = center, class:Tk

      layerrule = dimaround, wofi

      windowrule = float, class:qalculate-gtk

      windowrule = float, class:kitty, title:Notes
      windowrule = center, class:kitty, title:Notes
      windowrule = size 800 600, class:kitty, title:Notes
    '';

  xdg.portal.config = ''
        [preferred]
    default = hyprland;gtk;kde
    org.freedesktop.impl.portal.FileChooser = kde"
  '';
  };

}
