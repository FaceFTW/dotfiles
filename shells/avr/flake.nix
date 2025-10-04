{

  description = "AVR Dev Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      inherit (nixpkgs.lib)
        makeLibraryPath
        ;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.pkg-config
            ];
          };

          LD_LIBRARY_PATH = makeLibraryPath [
            pkgs.openssl.dev
          ];
        }
      );
    };
}
