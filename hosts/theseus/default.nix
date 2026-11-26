{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.determinate.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.bootvine.nixosModules.default
    ../../modules/core.nix
    ../../modules/kernel-build.nix
    ../../modules/kernel-tunables.nix
    ../../modules/packages
    ../../modules/services
    ../../modules/user.nix
    ./disks.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  ############################################
  # User Settings
  ############################################
  modules.users.default.password.type = "sops";
  modules.users.default.password.value = config.sops.secrets.user_passwd.path;
  modules.users.default.extraGroups = [
    "networkmanager"
    "syncthing"
  ];

  home-manager.backupFileExtension = "bak";

  ############################################
  # SOPS Settings
  ############################################
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.user_passwd.neededForUsers = true;
  sops.secrets."syncthing_cert.pem".key = "syncthing_cert_pem";
  sops.secrets."syncthing_cert.pem".owner = "face";
  sops.secrets."syncthing_key.pem".key = "syncthing_key_pem";
  sops.secrets."syncthing_key.pem".owner = "face";
  sops.secrets.nix_cache_pem.path = "/etc/secrets/nix_cache.pem";

  sops.secrets.nix-cache-credentials-user.key = "nix_cache_credentials";
  sops.secrets.nix-cache-credentials-user.path = "/home/face/.aws/credentials";
  sops.secrets.nix-cache-credentials-user.owner = "face";

  sops.secrets.nix-cache-credentials-root.key = "nix_cache_credentials";
  sops.secrets.nix-cache-credentials-root.path = "/root/.aws/credentials";

  ############################################
  # Misc System Configuration
  ############################################
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_ADDRESS = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_IDENTIFICATION = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_MEASUREMENT = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_MONETARY = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_NAME = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_NUMERIC = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_PAPER = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TELEPHONE = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "en_US.UTF-8";

  nix.settings.secret-key-files = "/run/secrets/nix_cache_pem";
  nix.settings.substituters = [
    "s3://nix-cache?endpoint=garage-s3.faceftw.dev"
  ];

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  fonts.packages = [
    pkgs.nerd-fonts.hack
    pkgs.ubuntu-sans
    pkgs.noto-fonts-color-emoji
  ];
  fonts.fontconfig.defaultFonts.monospace = [
    "Hack NF Mono"
    "Ubuntu Mono"
  ];

  # File picker for Hyprland
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

  ############################################
  # Global Packages
  ############################################
  modules.packages = {
    direnv.enable = true;
    fastfetch.enable = true;
    flameshot.enable = true;
    fraudshell.enable = true;
    git.enable = true;
    git.installFullGit = true;
    ly.enable = true;
    networking.enable = true;
    monitoring.enable = true;
    nix-tools.enable = true;
    nodejs.node = true;
    nodejs.biome = true;
    rust = "nightly";
    secrets.enable = true;
    ssh-client.enable = true;
    starship.enable = true;
    steam = true;
    styling.enable = true;
    vicinae.enable = true;
    virtualization.armVirtualization.enable = true;
    zed.enable = true;
    zsh.enable = true;

    # Hypr Ecosystem
    hyprland.enable = true;
    hyprland.filePicker = pkgs.xdg-desktop-portal-gtk;
    hyprland.configPath = ./hyprland.lua;
    hyprland.configSubstitutions =
      let
        hyprctl = "${pkgs.hyprland}/bin/hyprctl";
        systemctl = "${pkgs.systemd}/bin/systemctl";
      in
      [
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
          "${pkgs.vicinae}/bin/vicinae deeplink vicinae://launch/clipboard/history"
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
          "XXX_HYPRCTL_XXX"
          "${hyprctl}"
        ]
        [
          "--- XXX_EXTRA_STARTUP_XXX"
          # lua
          ''
            --- Background Nitty Gritty
            hl.exec_cmd("${systemctl} --user start hyprpolkitagent")
            hl.exec_cmd("${hyprctl} keyword input:kb_numlock true && date '+%Y-%m-%d %H:%M:%S' > /tmp/numlock-set")
            hl.exec_cmd("${hyprctl} setcursor rose-pine-hyprcursor 36")
            hl.exec_cmd("${hyprctl} dispatch workspace 1")
            hl.exec_cmd("${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets")

            --- Core Shell Experience
            hl.exec_cmd("${pkgs.hyprpaper}/bin/hyprpaper")
            hl.exec_cmd("sleep 1; ${pkgs.quickshell}/bin/quickshell -p /home/face/.config/quickshell/fraudshell")
            hl.exec_cmd("${pkgs.vicinae}/bin/vicinae server")

            --- User Autostart Apps
            hl.exec_cmd("sleep 10; ${systemctl} --user start syncthing")
            hl.exec_cmd("sleep 10; ${pkgs.keepassxc}/bin/keepassxc")
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

      ];

    hyprlock.enable = true;
    hyprlock.wallpaper = ./assets/fraud-3-wallpaper.png;
    hyprlock.userIcon = ./assets/face.png;

    hyprpaper.enable = true;
    hyprpaper.defaultWallpaper = "/home/face/.config/dotfiles/hosts/theseus/assets/fraud-1-wallpaper.png";
  };

  services.flatpak.enable = true;

  programs.thunar.enable = true;
  programs.thunar.plugins = [
    pkgs.thunar-volman
    pkgs.thunar-archive-plugin
  ];

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.alacritty
    pkgs.firefox
    pkgs.xdg-utils
    pkgs.gimp
    pkgs.inkscape
    pkgs.imhex
    pkgs.flameshot
    pkgs.freecad
    pkgs.keepassxc
    pkgs.rustdesk-flutter

    # For Tumbler
    pkgs.ffmpegthumbnailer
    pkgs.icoextract
    pkgs.webp-pixbuf-loader
  ];

  system.stateVersion = "25.05"; # Don't change this
}
