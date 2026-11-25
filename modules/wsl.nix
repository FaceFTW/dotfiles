{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.determinate.nixosModules.default
    inputs.nixos-wsl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    ./core.nix
    ./kernel-tunables.nix
    ./packages
    ./user.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  ############################################
  # User Settings
  ############################################
  # Didn't setup sops for WSL and don't plan to really...
  modules.users.default.password.type = "initialPassword";
  modules.users.default.password.value = "";
  modules.users.default.extraGroups = [ "docker" ];

  ############################################
  # WSL Configuration
  ############################################
  wsl.enable = true;
  wsl.defaultUser = "face";
  wsl.docker-desktop.enable = true;
  wsl.wslConf.automount.enabled = true;
  wsl.wslConf.user.default = "face";
  wsl.wslConf.interop.enabled = true;
  wsl.wslConf.interop.appendWindowsPath = false; # Let Linux binaries take precedence
  wsl.interop.register = true;
  modules.kernel.isWSL = true; # For Kernel Tunable Configs
  boot.kernelPackages = pkgs.linuxPackages_7_3;

  ############################################
  # Misc System Configuration
  ############################################
  # networking.hostName = "${WSLhostName}-wsl";
  time.timeZone = "America/New_York";
  systemd.services.nix-daemon = {
    serviceConfig.Environment = [ "AWS_SHARED_CREDENTIALS_FILE=%d/AWS_SHARED_CREDENTIALS_FILE" ];
    serviceConfig.LoadCredential = [ "AWS_SHARED_CREDENTIALS_FILE:/etc/secrets/aws/credentials" ];
  };

  nix.settings.secret-key-files = "/etc/secrets/nix-cache.pem";
  nix.settings.substituters = [
    "s3://nix-cache?region=archiver&endpoint=garage-s3.faceftw.dev"
  ];

  ############################################
  # Global Packages
  ############################################
  modules.packages = {
    direnv.enable = true;
    fastfetch.enable = true;
    git.enable = true;
    git.installFullGit = true;
    monitoring.enable = true;
    monitoring.ncdu.enable = true;
    networking.enable = true;
    nixTools.enable = true;
    nodejs.node = true;
    nodejs.biome = true;
    qtTools.enable = true;
    rust = "nightly";
    secrets.enable = true;
    secrets.wslGpgForwarding.enable = true;
    starship.enable = true;
    ssh-client.enable = true;
    virtualization.docker.enable = true;
    virtualization.armVirtualization.enable = true;
    zed.enable = true;
    zed.wslFixes = true;
    zsh.enable = true;
  };

  environment.systemPackages = [ ];

  system.stateVersion = "25.05";
}
