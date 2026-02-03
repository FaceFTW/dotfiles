{
  description = "";
  inputs = {
    # Core NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11-small";
    nixos-hardware.url = "github:FaceFTW/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Rust Toolchain
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # Lix
    lix.url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    lix.flake = false;

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.lix.follows = "lix";

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

    #Vicinae
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";

    # VS Code Extensions Mirror
    nix4vscode.url = "github:nix-community/nix4vscode";
    nix4vscode.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, ... }@inputs:
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
              builtins.attrNames (builtins.readDir "${(builtins.dirOf machinePath)}/overlays")
            )
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
      images.fabricator = nixosConfigurations.fabricator.config.system.build.sdImage;

      ############################################
      # archiver
      ############################################
      nixosConfigurations.archiver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = withOverlays ./hosts/archiver/default.nix;
      };
    };
}
