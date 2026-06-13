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
    ../../modules/home
    ../../modules/kernel-tunables.nix
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
  modules.users.default.password.type = "sops";
  modules.users.default.password.value = config.sops.secrets.user_passwd.path;
  modules.users.default.extraGroups = [
    "immich"
    "jellyfin"
  ];

  modules.home = {
    btop.enable = true;
    fastfetch.enable = true;
    git.enable = true;
    oh-my-posh.enable = true;
    ssh-client.enable = true;
    zsh.enable = true;
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

    garage_rpc_secret.owner = "garage";
    garage_rpc_secret.group = "garage";
    garage_admin_token.owner = "garage";
    garage_admin_token.group = "garage";
    garage_metrics_token.owner = "garage";
    garage_metrics_token.group = "garage";
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
