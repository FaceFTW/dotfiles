{
  config,
  pkgs,
  lib,
  ...
}:
let
  rust = config.packages.rust;
  inherit (lib)
    mkOption
    makeLibraryPath
    types
    mkIf
    lists
    ;
in
{
  options.packages.rust = mkOption {
    type =
      with types;
      nullOr (enum [
        "stable"
        "beta"
        "nightly"
      ]);
    default = null;
    description = "Rust Toolchain";
  };

  config = {
    environment.systemPackages = mkIf rust (
      lists.flatten [
        ############################################
        # Stable Toolchain
        ############################################
        (
          lists.optional rust == "stable" [
            (pkgs.fenix.stable.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-docs"
            ])
            (pkgs.rust-analyzer-nightly)
          ]
        )
        ############################################
        # Beta Toolchain
        ############################################
        (
          lists.optional rust == "beta" [
            (pkgs.fenix.stable.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-docs"
            ])
            (pkgs.rust-analyzer)
          ]
        )
        ############################################
        # Nightly Toolchain
        ############################################
        (
          lists.optional rust == "nightly" [
            (pkgs.fenix.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-docs"
            ])
            (pkgs.rust-analyzer-nightly)
          ]
        )

        ############################################
        # Common Dependencies
        ############################################
        [
          (pkgs.pkg-config)
          (pkgs.openssl.dev)
          (pkgs.llvmPackages_latest.bintools)
        ]
      ]

    );

    environment.variables = mkIf rust {
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
    };
  };

}
