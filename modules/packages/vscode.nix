{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
  inherit (lib) mkIf mkMerge mkEnableOption;

  extenstionPatches = {
    "rust-lang.rust-analyzer" =
      {
        pkgs,
        lib,
        system,
      }:
      {
        buildInputs = [ pkgs.rust-analyzer ];
      };
  };

  extensionsNix = pkgs.nix4vscode.forVscodeExt extenstionPatches (
    builtins.map (ext: ext.identifier.id) (
      builtins.filter (ext: ext.identifier ? uuid) (
        builtins.fromJSON (
          builtins.unsafeDiscardStringContext (builtins.readFile ../../config/vscode/extensions.json)
        )
      )
    )
  );
in
{
  options.packages.vscode.enable = mkEnableOption "Visual Studio Code";

  config = mkMerge [
    (mkIf packages.vscode.enable {
      programs.vscode.enable = true;
      programs.vscode.defaultEditor = false;
      programs.vscode.extensions = extensionsNix;

    })

  ];
}
