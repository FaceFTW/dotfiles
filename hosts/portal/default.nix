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
    inputs.nixos-wsl.nixosModules.default
    ../../modules/core.nix
    ../../modules/devtools.nix
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

  users.users = {
    ${user} = {
      name = "${user}";
      home = "/home/${user}";
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [ hostKey ];
      packages = [ pkgs.wslKeySetup ];
    };
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
  wsl.wslConf.interop.enabled = false;
  wsl.wslConf.interop.appendWindowsPath = false;
  kernel.isWSL = true; # For Kernel Configs

  ############################################
  # Program Options
  ############################################
  programs.zsh.enable = true;

  ############################################
  # Services
  ############################################
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false; # "Hardening"
  programs.gnupg.agent.enable = false; # Using GPG forwarding from Windows seen below
  systemd.services.win-gpg-forwarder.enable = true;
  systemd.services.win-gpg-forwarder.path = [ pkgs.socat ];
  systemd.services.win-gpg-forwarder.wantedBy = [ "default.target" ];
  systemd.services.win-gpg-forwarder.preStart = ''rm -f /run/user/1000/gnupg/S.gpg-agent'';
  systemd.services.win-gpg-forwarder.script = ''socat UNIX-LISTEN:"/run/user/1000/gnupg/S.gpg-agent,fork" EXEC:'/mnt/c/Users/awest/.local/bin/npiperelay.exe -ei -ep -s -a "C:/Users/awest/AppData/Local/gnupg/S.gpg-agent"',nofork'';

  ############################################
  # Misc System Configuration
  ############################################
  networking.hostName = "portal-wsl";
  time.timeZone = "America/New_York";

  ############################################
  # Global Packages
  ############################################
  packages.gitFull = true;
  packages.secretsMan = true;
  packages.monitoring = true;
  packages.ncdu = true;
  packages.networking = true;
  packages.nixTools = true;

  programs.devTools.rust = true;
  programs.devTools.patchVSCodeRemote = true;

  environment.systemPackages = with pkgs; [ ];

  environment.variables.FUNCNEST = 100000; # Fixes a potential issue with clear

  system.stateVersion = "25.05"; # Don't change this
}
