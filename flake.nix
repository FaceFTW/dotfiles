{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    lix.url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    lix.flake = false;

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.lix.follows = "lix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      nixos-hardware,
      fenix,
      lix-module,
      lix,
      ...
    }@inputs:
    let
      globalOverlays = builtins.map (n: import (./overlays + ("/" + n))) (
        (builtins.filter (n: builtins.match ".*\\.nix" n != null)) (
          builtins.attrNames (builtins.readDir ./overlays)
        )
      );
      # Assumes machine path
      specificOverlays =
        machinePath:
        if builtins.pathExists "${(builtins.dirOf machinePath)}/overlays" then
          (builtins.map (n: import ("${(builtins.dirOf machinePath)}/overlays" + ("/" + n))) (
            (builtins.filter (n: builtins.match ".*\\.nix" n != null)) (
              builtins.attrNames (builtins.readDir ./overlays)
            )
          ))
        else
          [ ];
      withOverlays = configModule: [
        {
          nixpkgs.overlays = [
            fenix.overlays.default
          ]
          ++ globalOverlays
          ++ (specificOverlays configModule);
        }
        configModule
      ];

    in
    rec {
      ############################################
      # manifold
      ############################################
      nixosConfigurations.manifold = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = withOverlays ./hosts/manifold/default.nix;
      };

      ############################################
      # portal
      ############################################

      nixosConfigurations.portal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = withOverlays ./hosts/portal/default.nix;
      };

      ############################################
      # fabricator
      ############################################
      nixosConfigurations.fabricator = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = withOverlays ./hosts/fabricator/default.nix;
      };
      images.fabricator = nixosConfigurations.fabricator.config.system.build.sdImage;
      # images.fabricator-printer-fw = nixosConfigurations.fabricator.config.

    };
}
