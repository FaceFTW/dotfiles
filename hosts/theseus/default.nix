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
    ./desktop
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
    "s3://nix-cache?region=archiver&endpoint=garage-s3.faceftw.dev"
  ];

  ############################################
  # Global Packages
  ############################################
  modules.packages.direnv = true;
  modules.packages.fastfetch.enable = true;
  modules.packages.fraudshell.enable = true;
  modules.packages.git.enable = true;
  modules.packages.git.installFullGit = true;
  modules.packages.networking = true;
  modules.packages.monitoring = true;
  modules.packages.nixTools = true;
  modules.packages.nodejs.node = true;
  modules.packages.nodejs.biome = true;
  modules.packages.rust = "nightly";
  modules.packages.secrets.base = true;
  modules.packages.ssh-client.enable = true;
  modules.packages.starship.enable = true;
  modules.packages.steam = true;
  modules.packages.virtualization.armVirtualization = true;
  modules.packages.zed.enable = true;
  modules.packages.zsh.enable = true;

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
    # pkgs.nvidia-offload
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
