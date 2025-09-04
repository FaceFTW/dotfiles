{
  config,
  inputs,
  pkgs,
  # agenix,
  ...
}:

let
  user = "face";

in
{
  imports = [
    ./secrets.nix
    # ./disk-config.nix
    ../../modules/fenix
    ../../modules/shared
    # agenix.nixosModules.default
  ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #   networking = {
  #     hostName = ""; # Define your hostname.
  #     useDHCP = false;
  #     interfaces."%INTERFACE%".useDHCP = true;
  #   };

  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings = {
      allowed-users = [ "${user}" ];
      trusted-users = [
        "@admin"
        "${user}"
      ];
    };

    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  # Manages keys and such
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;
  };

  services = {
    openssh.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
  };

  # Video support
  hardware = {
    graphics.enable = true;
    # nvidia.modesetting.enable = true;
  };

  # Add docker daemon
  virtualisation.docker.enable = true;
  virtualisation.docker.logDriver = "json-file";

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
  wsl = {
    enable = true;
    defaultUser = "face";
    docker-desktop.enable = true;
    wslConf.automount.enabled = true;
    wslConf.user.default = "face";
  };
}
