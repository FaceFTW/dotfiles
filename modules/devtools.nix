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
    ];

    virtualisation.docker = mkIf devTools.docker {
      enable = true;
      logDriver = "json-file";
    };
  };

}
