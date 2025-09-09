{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # agenix.url = "github:ryantm/agenix";

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
      fenix,
      # disko,
      # agenix,
      ...
    }@inputs:
    let
      user = "face";
      # devShell =
      #   system:
      #   let
      #     pkgs = nixpkgs.legacyPackages.${system};
      #   in
      #   {
      #     default =
      #       with pkgs;
      #       mkShell {
      #         nativeBuildInputs = with pkgs; [
      #           bashInteractive
      #           git
      #           age
      #           age-plugin-yubikey
      #         ];
      #         shellHook = with pkgs; ''
      #           export EDITOR=vim
      #         '';
      #       };
      #   };
      overlays = {
        nixpkgs.overlays = [
          fenix.overlays.default
          (import ./overlays/shell-toy.nix)
        ];
      };

    in
    {
      # devShells = devShell;
      nixosConfigurations = {
        manifold = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            overlays
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.face = ./hosts/manifold/home-manager.nix;
            }
            ./hosts/manifold/default.nix
          ];

        };
      };

      #   nixpkgs.lib.genAttrs linuxSystems (
      #   system:
      #   nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     specialArgs = inputs;
      #     modules = [
      #       disko.nixosModules.disko
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager = {
      #           useGlobalPkgs = true;
      #           useUserPackages = true;
      #           users.${user} = import ./modules/nixos/home-manager.nix;
      #         };
      #       }
      #       ./hosts/nixos
      #     ];
      #   }
      # );
    };
}
