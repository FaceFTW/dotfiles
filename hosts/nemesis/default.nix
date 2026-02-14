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
    inputs.silentSDDM.nixosModules.default
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages
    ../../modules/services
    ../../modules/user.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
    ./wm
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  ############################################
  # User Settings
  ############################################
  defaultUser.password.type = "sops";
  defaultUser.password.value = config.sops.secrets.user_passwd.path;
  defaultUser.extraGroups = [
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

  ############################################
  # Global Packages
  ############################################
  packages.monitoring = true;
  packages.networking = true;
  packages.secrets.base = true;
  packages.direnv = true;
  packages.ghidra = true;
  packages.gitFull = true;
  packages.nixTools = true;
  packages.rust = "nightly";
  packages.nodejs.node = true;
  packages.steam = true;
  packages.steam-nvidia-prime = true;
  packages.vscode.enable = true;

  services.flatpak.enable = true;
  # packages.zed.enable = true;

  programs.zsh.enable = true;
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
    pkgs.bitwarden-desktop
    pkgs.bitwarden-cli
    pkgs.gimp
    pkgs.inkscape
    pkgs.nvidia-offload
    pkgs.imhex
    pkgs.bottles

    # For Tumbler
    pkgs.ffmpegthumbnailer
    pkgs.icoextract
    pkgs.webp-pixbuf-loader
  ];

  system.stateVersion = "25.05"; # Don't change this
}
