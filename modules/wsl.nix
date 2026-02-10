{
  config,
  inputs,
  pkgs,
  lib,
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
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

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

    programs = (import ./home.nix { inherit config pkgs lib; });

    home.stateVersion = "25.05";

  };

  users.users.face = {
    home = "/home/face";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = [ pkgs.wslKeySetup ];
  };

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

  ############################################
  # Misc System Configuration
  ############################################
  # networking.hostName = "${WSLhostName}-wsl";
  time.timeZone = "America/New_York";

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
  packages.nodejs.vsCodeRemotePatch = true;
  packages.rust = "stable";
  packages.secrets.base = true;
  packages.secrets.wslGpgForwarding = true;
  packages.virtualization.docker = true;
  packages.virtualization.armVirtualization = true;
  # packages.zed.enable = true;
  # packages.zed.wslFixes = true;

  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  environment.systemPackages = [ ];

  system.stateVersion = "25.05";
}
