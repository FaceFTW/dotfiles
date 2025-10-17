{ inputs, pkgs, ... }:
let
  user = "face";
in
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../modules/core.nix
    ../../modules/kernel.nix
    ../../modules/packages.nix
    inputs.home-manager.nixosModules.home-manager
  ];

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
    ];
    packages = [ pkgs.wslKeySetup ];
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
  nix.package = pkgs.lix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.hostPlatform = "x86_64-linux";

  ############################################
  # WSL Configuration
  ############################################
  wsl.enable = true;
  wsl.defaultUser = "${user}";
  wsl.docker-desktop.enable = true;
  wsl.wslConf.automount.enabled = true;
  wsl.wslConf.user.default = "${user}";
  wsl.wslConf.interop.enabled = true;
  wsl.interop.register = true;
  wsl.wslConf.interop.appendWindowsPath = false; # Let Linux binaries take precedence
  kernel.isWSL = true; # For Kernel Configs

  ############################################
  # Program Options
  ############################################
  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  ############################################
  # Services
  ############################################
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.KbdInteractiveAuthentication = false;
  services.openssh.settings.AllowUsers = [ "face" ];

  ############################################
  # Misc System Configuration
  ############################################
  networking.hostName = "portal-wsl";
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

  environment.systemPackages = [ ];

  environment.variables.FUNCNEST = 100000; # Fixes a potential issue with clear

  system.stateVersion = "25.05"; # Don't change this
}
