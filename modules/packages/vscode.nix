{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    map
    filter
    fromJSON
    unsafeDiscardStringContext
    readFile
    ;

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
    map (ext: ext.identifier.id) (
      filter (ext: ext.identifier ? uuid) (
        fromJSON (unsafeDiscardStringContext (readFile ../../config/vscode/extensions.json))
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
