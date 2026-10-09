{
  description = "";
  inputs = {
    # Core NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
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
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprnix/hyprland";
    hyprland-plugins.inputs.nixpkgs.follows = "hyprnix/nixpkgs";

    # Hyprcursor
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    rose-pine-hyprcursor.inputs.nixpkgs.follows = "hyprnix/nixpkgs";

    # Silent SDDM Theme
    silentSDDM.url = "github:uiriansan/SilentSDDM";
    silentSDDM.inputs.nixpkgs.follows = "nixpkgs";

    #Vicinae
    vicinae.url = "github:vicinaehq/vicinae";
    # vicinae.inputs.nixpkgs.follows = "nixpkgs"; # use vicinae tied nixpkgs because of GCC mismatch issues
    vicinae-extensions.url = "github:vicinaehq/extensions";
    vicinae-extensions.inputs.nixpkgs.follows = "vicinae/nixpkgs";

    # FRAUDSHELL
    fraudshell.url = "path:./modules/fraudshell";
    fraudshell.inputs.nixpkgs.follows = "nixpkgs";
    fraudshell.inputs.fenix.follows = "fenix";
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
            inputs.fraudshell.overlays.default
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
