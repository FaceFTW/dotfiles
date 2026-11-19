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
    ../../modules/core.nix
    ../../modules/kernel-build.nix
    ../../modules/kernel-tunables.nix
    ../../modules/packages
    ../../modules/services
    ../../modules/user.nix
    ./disks.nix
    ./hardware.nix
    ./hypr.nix
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
    "s3://nix-cache?region=archiver&endpoint=garage-s3.faceftw.dev"
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
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
    direnv = true;
    fastfetch.enable = true;
    flameshot.enable = true;
    fraudshell.enable = true;
    git.enable = true;
    git.installFullGit = true;
    hyprlock.enable = true;
    hyprlock.wallpaper = ./assets/fraud-3-wallpaper.png;
    hyprlock.userIcon = ./assets/face.png;
    ly.enable = true;
    networking = true;
    monitoring = true;
    nixTools = true;
    nodejs.node = true;
    nodejs.biome = true;
    rust = "nightly";
    secrets.base = true;
    ssh-client.enable = true;
    starship.enable = true;
    steam = true;
    styling.enable = true;
    vicinae.enable = true;
    virtualization.armVirtualization = true;
    zed.enable = true;
    zsh.enable = true;
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
