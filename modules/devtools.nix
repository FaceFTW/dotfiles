{ config, pkgs, ... }:

let
  devTools = config.programs.devTools;
  inherit (pkgs.lib) mkIf mkEnableOption lists;
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
    # TODO why do I have to do the list twice????
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
        (pkgs.openssl)
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
