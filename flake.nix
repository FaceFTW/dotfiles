{
  description = "";
  inputs = {
    # Core NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11-small";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Rust Toolchain
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # Determinate nix
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Disko
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland Ecosystem
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprlock.url = "github:hyprwm/hyprlock";

    # Hyprcursor
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    rose-pine-hyprcursor.inputs.nixpkgs.follows = "nixpkgs";
    rose-pine-hyprcursor.inputs.hyprlang.follows = "hyprland/hyprlang";

    # Silent SDDM Theme
    silentSDDM.url = "github:uiriansan/SilentSDDM";
    silentSDDM.inputs.nixpkgs.follows = "nixpkgs";

    # ashell
    ashell.url = "github:MalpenZibo/ashell";

    #Vicinae
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";

    # VS Code Extensions Mirror
    nix4vscode.url = "github:nix-community/nix4vscode";
    nix4vscode.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, ashell, ... }@inputs:
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
            inputs.hyprland.overlays.default
            inputs.hyprland-plugins.overlays.default
            inputs.hyprpaper.overlays.default
            inputs.hyprlock.overlays.default
            inputs.nix4vscode.overlays.default
            (final: prev: {
              ashell = inputs.ashell.packages.${prev.stdenv.hostPlatform.system}.default;
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
        }
      );
    };
}
