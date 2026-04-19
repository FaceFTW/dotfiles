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
    ./kernel.nix
    ./packages
    ./user.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  ############################################
  # User Settings
  ############################################
  # Didn't setup sops for WSL and don't plan to really...
  defaultUser.password.type = "initialPassword";
  defaultUser.password.value = "";
  defaultUser.extraGroups = [ "docker" ];
  defaultUser.extraPackages = [ pkgs.wslKeySetup ];

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
  kernel.isWSL = true; # For Kernel Configs
  boot.kernelPackages = pkgs.linuxPackages_7_0;

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
    "s3://nix-cache?region=archiver&endpoint=192.168.0.172:3900&scheme=http"
  ];

  ############################################
  # Global Packages
  ############################################
  packages.direnv = true;
  packages.gitFull = true;
  packages.gnuMake = true;
  packages.monitoring = true;
  packages.ncdu = true;
  packages.networking = true;
  packages.nixTools = true;
  packages.nodejs.node = true;
  packages.nodejs.biome = true;
  # packages.nodejs.vsCodeRemotePatch = true;
  packages.rust = "stable";
  packages.secrets.base = true;
  packages.secrets.wslGpgForwarding = true;
  packages.virtualization.docker = true;
  packages.virtualization.armVirtualization = true;
  packages.zed.enable = true;
  packages.zed.wslFixes = true;

  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  environment.systemPackages = [ ];

  system.stateVersion = "25.05";
}
