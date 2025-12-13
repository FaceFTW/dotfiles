{
  config,
  inputs,
  pkgs,
  ...
}:
let
  user = "face";
in
{
  imports = [

    inputs.nixos-hardware.nixosModules.microsoft-surface-common
	inputs.nixos-hardware.nixosModules.common-cpu-intel
	inputs.nixos-hardware.nixosModules.common-gpu-intel
	inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.lix-module.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
    ./wm.nix
  ];

  ############################################
  # User Settings
  ############################################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.face = (import ./home-manager.nix);

  users.users.${user} = {
    home = "/home/${user}";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuQw4U+Wam1gjuEXyH/cObZfnfYiA/LPF0kjQPFTz9x face@manifold-wsl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3fuhneqp6s6Ye9hHb60QrXq8vlu5INzeKlgiPtO5Pq alex@faceftw.dev"
    ];
    initialPassword = ""; # For bootstrapping!
    # hashedPasswordFile = config.sops.secrets.user_passwd.path;
    packages = [ ];
  };

  # The following are system users/groups defined for various services
  # Unless they are defined elsewhere, in which here I document it for tracking
  users.groups.wifi = { }; # For ensuring wpa_supplicant can access the secrets reasonably

  ############################################
  # SOPS Settings
  ############################################
  # sops.defaultSopsFile = ./secrets.yaml;
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # sops.secrets.user_passwd.neededForUsers = true;
  # sops.secrets.wifi_secrets = {
  #   group = config.users.users.systemd-network.group;
  # };

  ############################################
  # Nix Settings
  ############################################
  nix.nixPath = [
    "nixos-config=/home/${user}/.config/dotfiles:/etc/nixos"
    "nixpkgs=flake:nixpkgs"
  ];
  nix.settings.allowed-users = [ "${user}" ];
  nix.settings.trusted-users = [
    "@admin"
    "${user}"
    "@wheel"
  ];
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.hostPlatform = "x86_64-linux";

  ############################################
  # Program Options
  ############################################
  programs.zsh.enable = true;

  ############################################
  # Services
  ############################################
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false; # "Hardening"

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

  services.udev.enable = true;

  ############################################
  # Global Packages
  ############################################
  packages.monitoring = true;
  packages.networking = true;
  packages.secrets.base = true;
  packages.direnv = true;
  packages.gitFull = true;
  packages.nixTools = true;
  packages.rust = "nightly";
  packages.nodejs.node = true;
  packages.steam = true;

  environment.systemPackages = [
    pkgs.sbctl
  ];

  system.stateVersion = "25.05"; # Don't change this
}
