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
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../modules/raspi
    ./services.nix
    ./udev.nix
    ./klipper.nix
  ];

  ############################################
  # SOPS Settings
  ############################################
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.user_passwd.neededForUsers = true;
  sops.secrets.wifi_secrets = { };

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
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3fuhneqp6s6Ye9hHb60QrXq8vlu5INzeKlgiPtO5Pq alex@faceftw.dev"
    ];
    # initialPassword = ""; #For bootstrapping!
    hashedPasswordFile = config.sops.secrets.user_passwd.path;
    packages = [ ];
  };

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
    download-buffer-size = 1073741824
  '';
  nixpkgs.hostPlatform = "aarch64-linux";

  ############################################
  # Hardware Configuration
  ############################################
  boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_rpi4;
  boot.kernelModules = [ ];
  boot.blacklistedKernelModules = [ "dw_hdmi" ];
  #   sdImage.populateFirmwareCommands = ''
  #     dtparam=i2c_arm=on
  #     dtparam=spi=on

  #     camera_auto_detect=1
  #     display_auto_detect=1

  #     auto_initramfs=1

  #     # dtoverlay=vc4-kms-v3d
  #     max_framebuffers=2
  #     disable_fw_kms_setup=1
  #     disable_overscan=1

  #     arm_64bit=1
  #     arm_boost=1

  #     [all]
  #     enable_uart=1
  #     max_usb_current=1
  #     start_x=1
  #     gpu_mem=128

  #   '';
  hardware.raspberry-pi."4".i2c1.enable = true;
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  hardware.deviceTree.enable = true;
  hardware.deviceTree.overlays = [
    {
      name = "spi";
      dtboFile = ./devicetree/spi0-0cs.dtbo;
    }
  ];

  ############################################
  # Program Options
  ############################################
  programs.zsh.enable = true;


  ############################################
  # Services
  ############################################
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false; # "Hardening"

  services.speechd.enable = false;
  services.printing.enable = false;
  services.getty.autologinUser = "face";

  ############################################
  # Networking Configuration
  ############################################
  networking.hostName = "fabricator";
  networking.firewall.allowedTCPPorts = [ 22 80 7125 ];
  networking.wireless.enable = true;
  networking.wireless.secretsFile = config.sops.secrets.wifi_secrets.path;
  networking.wireless.networks."Orbi89".pskRaw = "ext:home-psk";
  services.avahi.enable = true;

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

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  environment.variables.FUNCNEST = 100000; # Fixes a potential issue with clear

  system.stateVersion = "25.05"; # Don't change this
}
