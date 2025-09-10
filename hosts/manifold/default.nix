{
  config,
  inputs,
  pkgs,
  ...
}:

let
  user = "face";
  # Windows SSH Key (Used for VS Code Integration)
  hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold";
in
{
  imports = [
    ../../modules/core.nix
    ../../modules/devtools.nix
    ../../modules/kernel.nix
    # agenix.nixosModules.default
  ];

  ############################################
  # Nix Settings
  ############################################

  nix.nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
  nix.settings.allowed-users = [ "${user}" ];
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
  # WSL Configuration
  ############################################
  wsl.enable = true;
  wsl.defaultUser = "face";
  wsl.docker-desktop.enable = true;
  wsl.wslConf.automount.enabled = true;
  wsl.wslConf.user.default = "face";
  kernel.isWSL = true; # For Kernel Configs

  ############################################
  # Program Options
  ############################################
  programs.gnupg.agent.enable = true;
  programs.zsh.enable = true;
  programs.devTools.rust = true;
  programs.devTools.docker = true;
  programs.devTools.node = true;
  programs.devTools.patchVSCodeRemote = true;

  ############################################
  # Services
  ############################################
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false; # "Hardening"
  services.gvfs.enable = true; # Mount, trash, and other functionalities

  ############################################
  # Misc System Configuration
  ############################################
  networking.hostName = "manifold-wsl";

  time.timeZone = "America/New_York";

  hardware.graphics.enable = true;
  # hardware.nvidia.modesetting.enable = true;

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [ hostKey ];
    };
  };

  ############################################
  # Global Packages
  ############################################
  environment.systemPackages = with pkgs; [
    # agenix.packages."${pkgs.system}".default # "x86_64-linux"
    gitAndTools.gitFull
    inetutils
  ];

  system.stateVersion = "25.05"; # Don't change this
}
