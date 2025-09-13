{
  description = "Starter Configuration with secrets for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
      fenix,
      # disko,
      ...
    }@inputs:
    let
      user = "face";
      overlays = {
        nixpkgs.overlays = [
          fenix.overlays.default
          (import ./overlays/shell-toy.nix)
          (import ./overlays/wsl-key-setup.nix)
        ];
      };

    in
    {
      nixosConfigurations = {
        ############################################
        # manifold
        ############################################
        manifold = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            overlays
            nixos-wsl.nixosModules.default
            ./hosts/manifold/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.face = (import ./hosts/manifold/home-manager.nix);
            }
          ];

        ############################################
        # portal
        ############################################
        portal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            overlays
            nixos-wsl.nixosModules.default
            ./hosts/portal/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.face = (import ./hosts/portal/home-manager.nix);
            }
          ];

        };
      };
    };
}
