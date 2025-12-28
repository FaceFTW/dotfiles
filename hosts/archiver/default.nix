{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  user = "face";
in
{
  imports = [
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ./disks.nix
    ./networking.nix
    ./services.nix
  ];

  ############################################
  # User Settings
  ############################################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.face = {
    home.enableNixpkgsReleaseCheck = false;
    home.username = "face";
    home.homeDirectory = "/home/face";
    xdg.enable = true;

    programs = (import ../../modules/home.nix { inherit config pkgs lib; });

    home.stateVersion = "25.05";
  };

  users.users.${user} = {
    home = "/home/${user}";
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuQw4U+Wam1gjuEXyH/cObZfnfYiA/LPF0kjQPFTz9x face@manifold-wsl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3fuhneqp6s6Ye9hHb60QrXq8vlu5INzeKlgiPtO5Pq alex@faceftw.dev"
    ];
    # initialPassword = ""; #For bootstrapping!
    hashedPasswordFile = config.sops.secrets.user_passwd.path;
    packages = [ ];
  };

  # The following are system users/groups defined for various services
  # Unless they are defined elsewhere, in which here I document it for tracking

  ############################################
  # SOPS Settings
  ############################################
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.user_passwd.neededForUsers = true;
  sops.secrets.pushover_api_key = { };
  sops.secrets.pushover_user_key = { };

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
  # Hardware Configuration
  ############################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.extraModulePackages = [ pkgs.kernelModules.ugreen_led ];
  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;

  boot.initrd.kernelModules = [ "mmc_block" ];
  boot.kernelModules = [
    "mmc_block"
    "led-ugreen"
    "i2c-dev"
    "ledtrig-netdev"
    "ledtrig-oneshot"
  ];
  hardware.enableAllHardware = true;

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

  services.udev.enable = true;

  ############################################
  # Global Packages
  ############################################
  packages.monitoring = true;
  packages.networking = true;
  packages.secrets.base = true;

  system.stateVersion = "25.05"; # Don't change this
}
