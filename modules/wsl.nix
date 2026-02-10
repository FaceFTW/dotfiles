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
    inputs.determinate.nixosModules.default
    inputs.nixos-wsl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    ./core.nix
    ./kernel.nix
    ./packages
  ];

  config = {
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

    users.users.${user} = {
      home = "/home/${user}";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      shell = pkgs.zsh;
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
    # nix.package = pkgs.lix;
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

    environment.systemPackages = [ ];

    system.stateVersion = "25.05";
  };
}
