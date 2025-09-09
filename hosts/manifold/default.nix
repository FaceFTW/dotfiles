{
  config,
  inputs,
  pkgs,
  fenix,
  # agenix,

  ...
}:

let
  user = "face";
  fenix = fenix;
in
{
  imports = [
    ./secrets.nix
    ../../modules/devtools.nix
    ../../modules/shared/core.nix
    # agenix.nixosModules.default
  ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #   networking = {
  #     hostName = ""; # Define your hostname.
  #     useDHCP = false;
  #     interfaces."%INTERFACE%".useDHCP = true;
  #   };

  ############################################
  # Nix Settings
  ############################################

  nix.nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
  nix.settings.allowed-users = [ "${user}" ];
  nix.settings.trusted-users = [
    "@admin"
    "${user}"
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

  ############################################
  # Program Options
  ############################################
  programs.gnupg.agent.enable = true;
  programs.zsh.enable = true;
  programs.devTools.rust = true;
  programs.devTools.docker = true;
  programs.devTools.node = true;

  ############################################
  # Services
  ############################################
  services.openssh.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Video support
  hardware = {
    graphics.enable = true;
    # nvidia.modesetting.enable = true;
  };

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
      shell = pkgs.zsh;
      # openssh.authorizedKeys.keys = keys;
    };

    # root = {
    #   openssh.authorizedKeys.keys = keys;
    # };
  };

  environment.systemPackages = with pkgs; [
    # agenix.packages."${pkgs.system}".default # "x86_64-linux"
    gitAndTools.gitFull
    inetutils
  ];

  system.stateVersion = "25.05"; # Don't change this
}
