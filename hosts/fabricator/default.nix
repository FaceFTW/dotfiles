{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages
    ./hardware.nix
    ./klipper.nix
    ./networking.nix
    ./sd-image
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

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

  users.users.face = {
    home = "/home/face";
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    initialPassword = "***REMOVED***"; # For bootstrapping!
    # hashedPasswordFile = config.sops.secrets.user_passwd.path;
    packages = [ ];
  };

  # The following are system users/groups defined for various services
  # Unless they are defined elsewhere, in which here I document it for tracking
  #
  users.groups.camera = { }; # For accessing the camera via udev
  users.groups.wifi = { }; # For ensuring wpa_supplicant can access the secrets reasonably
  # users.users.klipper = {}; # Klipper system user for Klipper/Moonraker/Nginx

  ############################################
  # SOPS Settings
  ############################################
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.user_passwd.neededForUsers = true;
  sops.secrets.wifi_secrets = {
    group = config.users.users.systemd-network.group;
  };
  sops.secrets.moonraker_key = { };

  ############################################
  # Services
  ############################################
  services-custom.ssh-server.enable = true;
  services-custom.ssh-server.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuQw4U+Wam1gjuEXyH/cObZfnfYiA/LPF0kjQPFTz9x face@manifold-wsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3fuhneqp6s6Ye9hHb60QrXq8vlu5INzeKlgiPtO5Pq alex@faceftw.dev"
  ];

  services.speechd.enable = false;
  services.printing.enable = false;
  # services.getty.autologinUser = "face";

  ############################################
  # Misc System Configuration
  ############################################
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];
  time.timeZone = "America/New_York";

  ############################################
  # Global Packages
  ############################################
  packages.monitoring = true;
  packages.networking = true;
  packages.secrets.base = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    firefox
  ];

  system.stateVersion = "25.05"; # Don't change this
}
