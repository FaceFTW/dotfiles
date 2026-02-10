{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.determinate.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages
    ../../modules/services
    ../../modules/user.nix
    ./disks.nix
    ./networking.nix
    ./nginx.nix
    ./services.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  ############################################
  # User Settings
  ############################################
  defaultUser.password.type = "sops";
  defaultUser.password.value = config.sops.secrets.user_passwd.path;
  defaultUser.extraGroups = [
    "immich"
    "jellyfin"
  ];

  home-manager.users.face = {
    programs.btop = {
      enable = true;
      settings.color_theme = "TTY";
      settings.theme_background = true;
      settings.force_tty = false;
      settings.terminal_sync = true;
      settings.clock_format = "/host - %x %X";
      settings.presets = "cpu:0:default,mem:0:default,net:0:default";
      settings.update_ms = 2000;
      settings.log_level = "WARNING";

      settings.graph_symbol = "block";
      settings.graph_symbol_cpu = "tty";
      settings.graph_symbol_mem = "tty";
      settings.graph_symbol_net = "block";
      settings.shown_boxes = "mem cpu net";

      settings.cpu_graph_upper = "total";
      settings.cpu_graph_lower = "system";
      settings.cpu_single_graph = false;
      settings.cpu_bottom = false;
      settings.show_uptime = true;
      settings.show_cpu_watts = true;
      settings.check_temp = true;
      settings.cpu_sensor = "Auto";
      settings.show_coretemp = true;
      settings.temp_scale = "celsius";
      settings.base_10_sizes = false;
      settings.show_cpu_freq = true;

      settings.mem_graphs = false;
      settings.mem_below_net = false;
      settings.show_swap = true;

      settings.show_disks = true;
      settings.disks_filter = "/mnt/archive /mnt/motorway";
      settings.swap_disk = false;
      settings.use_fstab = true;
      settings.zfs_hide_datasets = true;
      settings.disk_free_priv = true;
      settings.show_io_stat = false;

      settings.net_auto = true;
      settings.net_sync = true;
      settings.net_iface = "enp2s0";
      settings.base_10_bitrate = "false";
      settings.show_battery = false;

    };
  };

  ############################################
  # SOPS Settings
  ############################################
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.user_passwd.neededForUsers = true;
  sops.secrets.pushover_api_key = { };
  sops.secrets.pushover_user_key = { };
  sops.secrets.immich_secrets.owner = "immich";
  sops.secrets.immich_secrets.group = "immich";
  sops.secrets."syncthing/cert.pem".key = "syncthing_cert_pem";
  sops.secrets."syncthing/key.pem".key = "syncthing_key_pem";
  sops.secrets.linkwarden_nextauth_secret.owner = "linkwarden";
  sops.secrets.linkwarden_nextauth_secret.group = "linkwarden";
  sops.secrets.linkwarden_postgres_password.owner = "linkwarden";
  sops.secrets.linkwarden_postgres_password.group = "linkwarden";

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
  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [
    pkgs.intel-ocl
    pkgs.intel-media-driver
    pkgs.vpl-gpu-rt
  ];

  ############################################
  # Program Options
  ############################################
  programs.zsh.enable = true;

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

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  system.stateVersion = "25.05"; # Don't change this
}
