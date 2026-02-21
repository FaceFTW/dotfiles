{
  pkgs,
  ...
}:
let
  inherit (pkgs) lib;
in
pkgs.mkShell {
  packages = [
    (pkgs.fenix.complete.withComponents [
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

  LIBCLANG_PATH = lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
  RUSTFLAGS = (
    builtins.map (a: "-L ${a}/lib") [
      (pkgs.openssl.dev)
    ]
  );
  LD_LIBRARY_PATH = lib.makeLibraryPath [
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
      "-I${pkgs.glib.out}/lib/glib-2.0/include/"
    ];
}
