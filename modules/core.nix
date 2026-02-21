{
  pkgs,
  ...
}:
{
  ############################################
  # Nixpkgs Common Config
  ############################################
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowInsecure = false;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.documentation.doc.enable = false;
  nixpkgs.config.documentation.info.enable = false;
  nixpkgs.config.nvidia.acceptLicense = true;

  ############################################
  # Nix Common Settings
  ############################################
  nix.nixPath = [
    "nixos-config=/home/face/.config/dotfiles:/etc/nixos"
    "nixpkgs=flake:nixpkgs"
  ];
  nix.settings.allowed-users = [ "face" ];
  nix.settings.trusted-users = [
    "@admin"
    "face"
    "@wheel"
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings.warn-dirty = false;
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
    "https://vicinae.cachix.org"
    "https://hyprland.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];
  nix.settings.auto-optimise-store = true;

  environment.etc."determinate/config.json".text = ''
    {
      "garbageCollector": {
        "strategy": "disabled"
      },
      "builder": {
        "cpuCount": 4
      }
    }
  '';

  ############################################
  # Sudo Settings
  ############################################
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
  # So passwords can be set. Aside from root, I should be able to do this
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "${pkgs.shadow}/bin/chpasswd";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  ############################################
  # Environment Variables
  ############################################
  environment.sessionVariables.EDITOR = "vim";
}
