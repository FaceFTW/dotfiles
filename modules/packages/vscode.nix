{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
  inherit (lib) mkIf mkMerge mkEnableOption;

  # extensionsJson = builtins.fromJSON (
  #   builtins.unsafeDiscardStringContext (builtins.readFile ../../config/vscode/extensions.json)
  # );
  extensionsNix =
    builtins.map
      (
        extJson:
        builtins.getAttr extJson.name (
          builtins.getAttr extJson.author pkgs.nix-vscode-extensions.vscode-marketplace-universal
        )
      )
      (
        builtins.map
          (arr: {
            author = (builtins.elemAt (builtins.elemAt arr 1) 0);
            name = (builtins.elemAt (builtins.elemAt arr 1) 1);
          })
          (
            builtins.map (ext: builtins.split "([[:alnum:]|_-]+)\.([[:alnum:]|_-]+)" ext.identifier.id) (
              builtins.filter (ext: ext.identifier ? uuid) (
                builtins.fromJSON (
                  builtins.unsafeDiscardStringContext (builtins.readFile ../../config/vscode/extensions.json)
                )
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
