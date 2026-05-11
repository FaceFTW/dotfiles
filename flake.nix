{
  description = "";
  inputs = {
    # Core NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Rust Toolchain
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # Determinate nix
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    determinate.inputs.nixpkgs.follows = "nixpkgs";

    # sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Disko
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland Ecosystem
    hyprnix.url = "github:hyprwm/hyprnix";
    hyprnix.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins"; # pin until hyprland 0.55 is released
    hyprland-plugins.inputs.hyprland.follows = "hyprnix/hyprland";
    hyprland-plugins.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprcursor
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    rose-pine-hyprcursor.inputs.nixpkgs.follows = "nixpkgs";
    rose-pine-hyprcursor.inputs.hyprlang.follows = "hyprnix/hyprlang";

    # Silent SDDM Theme
    silentSDDM.url = "github:uiriansan/SilentSDDM";
    silentSDDM.inputs.nixpkgs.follows = "nixpkgs";

    #Vicinae
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae.inputs.nixpkgs.follows = "nixpkgs";
    vicinae-extensions.url = "github:vicinaehq/extensions";
    vicinae-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      ############################################
      # Overlay Setup
      ############################################
      globalOverlays =
        with lib;
        map (n: import (./overlays + ("/" + n))) (
          (filter (n: match ".*\\.nix" n != null)) (attrNames (readDir ./overlays))
        );
      # Assumes machine path
      specificOverlays =
        machinePath:
        with lib;
        if pathExists "${(dirOf machinePath)}/overlays" then
          (map (n: import ("${(dirOf machinePath)}/overlays" + ("/" + n))) (
            (filter (n: match ".*\\.nix" n != null)) (attrNames (readDir "${(dirOf machinePath)}/overlays"))
          ))
        else
          [ ];
      withOverlays = configModule: [
        {
          nixpkgs.overlays = [
            inputs.fenix.overlays.default
            inputs.vicinae.overlays.default
            inputs.hyprnix.overlays.default
            inputs.hyprland-plugins.overlays.default
            (final: prev: {
              hyprland = prev.hyprland.override {
                hyprgraphics = inputs.hyprnix.packages.${prev.stdenv.hostPlatform.system}.hyprgraphics;
              };

            })
          ]
          ++ globalOverlays
          ++ (specificOverlays configModule);
        }
        configModule
      ];

      ############################################
      # Dev Shell Utils
      ############################################
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    rec {
      ############################################
      # manifold
      ############################################
      nixosConfigurations.manifold = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = withOverlays ./modules/wsl.nix ++ [ { networking.hostName = "manifold-wsl"; } ];
      };

      ############################################
      # portal
      ############################################
      nixosConfigurations.portal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = withOverlays ./modules/wsl.nix ++ [ { networking.hostName = "portal-wsl"; } ];
      };

      ############################################
      # nemesis
      ############################################
      nixosConfigurations.nemesis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = withOverlays ./hosts/nemesis/default.nix;
      };

      ############################################
      # fabricator
      ############################################
      nixosConfigurations.fabricator = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = withOverlays ./hosts/fabricator/default.nix;
      };
      images.fabricator = nixosConfigurations.fabricator.config.system.build.image;

      ############################################
      # archiver
      ############################################
      nixosConfigurations.archiver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = withOverlays ./hosts/archiver/default.nix;
      };

      ############################################
      # durandal
      ############################################
      nixosConfigurations.durandal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = withOverlays ./hosts/durandal/default.nix;
      };
      images.durandal = nixosConfigurations.durandal.config.system.build.image;

      ############################################
      # Dev Shells
      ############################################
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.fenix.overlays.default
            ];
          };
        in
        {
          rust = import ./shells/rust.nix { inherit pkgs system; };
          troubleshoot = import ./shells/troubleshoot.nix { inherit pkgs system; };
        }
      );
    };
}

#######################################
# OLD FRAGMENTS THAT I MAY NEED AGAIN
#######################################
# nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11-small";
#
# ashell - used in deep-blue
# ashell.url = "github:MalpenZibo/ashell";
# ashell.inputs.nixpkgs.follows = "nixpkgs";
#
# VS Code Extensions Mirror
# nix4vscode.url = "github:nix-community/nix4vscode";
# nix4vscode.inputs.nixpkgs.follows = "nixpkgs";
#
# overlay vvv
# inputs.nix4vscode.overlays.default
# (final: prev: {
#   ashell = inputs.ashell.packages.${prev.stdenv.hostPlatform.system}.default;
# })
