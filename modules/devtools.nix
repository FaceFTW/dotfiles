{ config, pkgs, ... }:

let
  devTools = config.programs.devTools;
  inherit (pkgs.lib)
    mkIf
    mkEnableOption
    lists
    makeLibraryPath
    ;
in
{
  imports = [ ];

  options.programs.devTools = {
    rust = mkEnableOption "Rust Toolchain";
    docker = mkEnableOption "Docker";
    node = mkEnableOption "NodeJS";
    patchVSCodeRemote = mkEnableOption "VS Code Remote Server Patch";
  };

  config = {
    environment.systemPackages = lists.flatten [
      # Rust Packages
      (lists.optional devTools.rust [
        (pkgs.fenix.stable.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
          "rust-docs"
        ])
        (pkgs.fenix.complete.withComponents [
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        (pkgs.rust-analyzer-nightly)
        (pkgs.pkg-config)
        (pkgs.openssl.dev)
        (pkgs.clang)
        (pkgs.llvmPackages_21.bintools)
      ])
      # Docker Packages
      (lists.optional devTools.docker [
        pkgs.docker
        pkgs.docker-compose
      ])
      # Node Packages
      (lists.optional devTools.node [
        pkgs.nodejs_24
      ])
    ];

    # Extra environment variables for Rust
    environment.variables = mkIf devTools.rust {
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

    virtualisation.docker = mkIf devTools.docker {
      enable = true;
      logDriver = "json-file";
    };

    # Quick Workaround for VS Code Remote
    # Assumes Node is Enabled with devTools
    systemd.user.paths.vscode-remote-workaround = mkIf devTools.patchVSCodeRemote {
      wantedBy = [ "default.target" ];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
    };
    systemd.user.services.vscode-remote-workaround.script = mkIf devTools.patchVSCodeRemote ''
      for i in ~/.vscode-server/bin/*; do
        echo "Fixing vscode-server in $i..."
        ln -sf ${pkgs.nodejs_24}/bin/node $i/node
      done
    '';

  };

}
