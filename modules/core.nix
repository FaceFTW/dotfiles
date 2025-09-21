{ config, pkgs, ... }:
{
  ############################################
  # Nixpkgs Common Config
  ############################################
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowInsecure = false;
  nixpkgs.config.allowUnsupportedSystem = true;

  ############################################
  # Nix Common Settings
  ############################################
  nix.settings.warn-dirty = false;
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

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
          command = "${pkgs.shadow}/bin/passwd face";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
