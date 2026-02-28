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
    ./hardware.nix
    ./networking.nix
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
  sops.secrets = {
    user_passwd.neededForUsers = true;

    pushover_api_key = { };
    pushover_user_key = { };

    immich_secrets.owner = "immich";
    immich_secrets.group = "immich";

    "syncthing/cert.pem".key = "syncthing_cert_pem";
    "syncthing/key.pem".key = "syncthing_key_pem";

    linkwarden_nextauth_secret.owner = "linkwarden";
    linkwarden_nextauth_secret.group = "linkwarden";
    linkwarden_postgres_password.owner = "linkwarden";
    linkwarden_postgres_password.group = "linkwarden";
  };

  ############################################
  # Misc System Configuration
  ############################################
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console.earlySetup = true;
  console.packages = [ pkgs.terminus_font ];
  console.font = "ter-v14n";
  console.useXkbConfig = true;

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  ############################################
  # Global Packages
  ############################################
  packages.monitoring = true;
  packages.networking = true;
  packages.secrets.base = true;

  programs.zsh.enable = true;

  environment.systemPackages = [
    pkgs.terminus_font
  ];

  system.stateVersion = "25.05"; # Don't change this
}
