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
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages.nix
    ./disks.nix
    ./networking.nix
    ./nginx.nix
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

    programs = lib.mkMerge [
      (import ../../modules/home.nix { inherit config pkgs lib; })
      {
        btop.enable = true;
        btop.settings.color_theme = "TTY";
        btop.settings.theme_background = true;
        btop.settings.force_tty = false;
        btop.settings.terminal_sync = true;
        btop.settings.clock_format = "/host - %x %X";
        btop.settings.presets = "cpu:0:default,mem:0:default,net:0:default";
        btop.settings.update_ms = 2000;
        btop.settings.log_level = "WARNING";

        btop.settings.graph_symbol = "block";
        btop.settings.graph_symbol_cpu = "tty";
        btop.settings.graph_symbol_mem = "tty";
        btop.settings.graph_symbol_net = "block";
        btop.settings.shown_boxes = "mem cpu net";

        btop.settings.cpu_graph_upper = "total";
        btop.settings.cpu_graph_lower = "system";
        btop.settings.cpu_single_graph = false;
        btop.settings.cpu_bottom = false;
        btop.settings.show_uptime = true;
        btop.settings.show_cpu_watts = true;
        btop.settings.check_temp = true;
        btop.settings.cpu_sensor = "Auto";
        btop.settings.show_coretemp = true;
        btop.settings.temp_scale = "celsius";
        btop.settings.base_10_sizes = false;
        btop.settings.show_cpu_freq = true;

        btop.settings.mem_graphs = false;
        btop.settings.mem_below_net = false;
        btop.settings.show_swap = true;

        btop.settings.show_disks = true;
        btop.settings.disks_filter = "/mnt/archive /mnt/motorway";
        btop.settings.swap_disk = false;
        btop.settings.use_fstab = true;
        btop.settings.zfs_hide_datasets = true;
        btop.settings.disk_free_priv = true;
        btop.settings.show_io_stat = false;

        btop.settings.net_auto = true;
        btop.settings.net_sync = true;
        btop.settings.net_iface = "enp2s0";
        btop.settings.base_10_bitrate = "false";
        btop.settings.show_battery = false;

      }
    ];
    home.stateVersion = "25.05";
  };

  users.users.${user} = {
    home = "/home/${user}";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "photoprism"
      "jellyfin"
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
  sops.secrets.photoprism_admin_pass.owner = "photoprism";
  sops.secrets.photoprism_admin_pass.group = "photoprism";


  ############################################
  # Nix Settings
  ############################################
  nix.nixPath = [
    "nixos-config=/home/${user}/.config/dotfiles:/etc/nixos"
    "nixpkgs=flake:nixpkgs"
  ];
  nix.settings.allowed-users = [
    "${user}"
    "nix-serve"
  ];
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
  boot.loader.systemd-boot.configurationLimit = 2;

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "uas"
    "sd_mod"
    "sdhci_pci"
    "mmc_block"
  ];
  boot.initrd.systemd.enable = true;

  boot.extraModulePackages = [ pkgs.kernelModules.ugreen_led ];
  boot.kernelModules = [
    "led-ugreen"
    "i2c-dev"
    "ledtrig-netdev"
    "ledtrig-oneshot"
    "igc"
    "kvm-intel"
    "i915"
  ];
  boot.kernelParams = [
    "pcie_port_pm=off"
    "pcie_aspm.policy=performance"
    "consoleblank=0"
    "fbcon=logo-count:1"
    "fbcon=font:ter-v14n"
    "vconsole.font=ter-v14n"
  ];
  # boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  # boot.loader.systemd-boot.memtest86.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

  ############################################
  # Program Options
  ############################################
  programs.zsh.enable = true;

  ############################################
  # Services
  ############################################
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false; # "Hardening"

  # Autostart btop monitor as a kiosk
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    # serviceConfig.ExecPreStart = [
    #   ""
    #   # "setfont ter-v14n"
    # ];
    serviceConfig.ExecStart = [
      ""
      "${pkgs.btop}/bin/btop --config /home/face/.config/btop/btop.conf --preset 1 --force-utf --no-tty"
    ];
    serviceConfig.User = "face"; # this is unconventional
    serviceConfig.Group = "users";
  };

  ############################################
  # Misc System Configuration
  ############################################
  time.timeZone = "America/New_York";

  services.udev.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  console.earlySetup = true;
  console.packages = [ pkgs.terminus_font ];
  console.font = "ter-v14n";
  console.useXkbConfig = true;

  ############################################
  # Global Packages
  ############################################
  packages.monitoring = true;
  packages.networking = true;
  packages.secrets.base = true;

  environment.systemPackages = [
    pkgs.terminus_font
  ];

  system.stateVersion = "25.05"; # Don't change this
}
