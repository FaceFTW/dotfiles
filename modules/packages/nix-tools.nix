{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.modules.packages.nix-tools = {
    enable = lib.mkEnableOption "Nix-related Tools";
  };

  config = lib.mkIf config.modules.packages.nix-tools.enable {
    environment.systemPackages = [
      pkgs.nixfmt
      pkgs.nix-tree
      pkgs.nix-index
      pkgs.nil

      (pkgs.writeShellApplication {
        name = "prune-nix-cache";

        runtimeInputs = [
          pkgs.findutils # for xargs
          pkgs.gawk
          pkgs.gnugrep
          pkgs.gnused
          pkgs.jq
          inputs.determinate.packages.${pkgs.stdenv.hostPlatform.system}.default # ensure we use determinate nix
          pkgs.s5cmd
          pkgs.uutils-coreutils-noprefix # echo, mktemp, sort
        ];

        text = builtins.readFile ../../bin/prune-nix-cache.sh;
      })
    ];
  };
}
