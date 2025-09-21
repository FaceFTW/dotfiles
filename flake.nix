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

    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      nixos-hardware,
      fenix,
      # disko,
      ...
    }@inputs:
    let
      user = "face";
      withOverlays = configModule: [
        {
          nixpkgs.overlays = [
            fenix.overlays.default
            (import ./overlays/shell-toy.nix)
            (import ./overlays/wsl-key-setup.nix)
            (import ./overlays/vim.nix)
          ];
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
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = withOverlays ./hosts/fabricator/default.nix;
      };
      images.fabricator = nixosConfigurations.fabricator.config.system.build.sdImage;

    };
}
