# The reason why I have this decoupled from modules is
# because it makes it easier to copy it into projects
# as I might need it
{
  description = "Rust Dev Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
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
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ fenix.overlays.default ];
          };
        in
        {
          default = pkgs.mkShell {
            packages = [
              (pkgs.fenix.complete.withComponents
              [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
                "rust-docs"
              ])
              pkgs.rust-analyzer-nightly
              pkgs.pkg-config
              pkgs.openssl.dev
              pkgs.llvmPackages_latest.bintools
            ];
          };

          LIBCLANG_PATH = makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
          RUSTFLAGS = (
            builtins.map (a: ''-L ${a}/lib'') [
              (pkgs.openssl.dev)
            ]
          );
          LD_LIBRARY_PATH = makeLibraryPath [
            pkgs.openssl.dev
          ];
          BINDGEN_EXTRA_CLANG_ARGS =
            (builtins.map (a: ''-I"${a}/include"'') [
              pkgs.glibc.dev
              pkgs.openssl.dev
            ])
            # Includes with special directory paths
            ++ [
              ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
              ''-I"${pkgs.glib.dev}/include/glib-2.0"''
              ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
            ];
        }
      );
    };
}
