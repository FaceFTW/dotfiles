{
  inputs,
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
    mkOption
    types
    ;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];
  options.packages.zed.enable = mkEnableOption "Zed Editor";
  options.packages.zed.wslFixes = mkEnableOption "Systemd service to start the Zed remote server automatically";

  options.packages.zed.linkConfig = mkEnableOption "Symlink to common Zed config";
  options.packages.zed.config.uiFontSize = mkOption {
    type = types.number;
    description = "Font Size for the Zed UI";
    default = 14;
  };
  options.packages.zed.config.bufferFontSize = mkOption {
    type = types.number;
    description = "Font Size for the buffers in Zed";
    default = 12;
  };
  options.packages.zed.config.terminalFontSize = mkOption {
    type = types.number;
    description = "Font Size for the Zed Terminal buffers";
    default = 11;
  };

  config = mkMerge [
    (mkIf packages.zed.enable {
      environment.systemPackages = [
        pkgs.zed-editor
        pkgs.openssl
        pkgs.package-version-server
      ];
    })
    (mkIf packages.zed.wslFixes {
      wsl.extraBin = [
        { src = "${pkgs.coreutils}/bin/uname"; }
        { src = "${pkgs.coreutils}/bin/mkdir"; }
        { src = "${pkgs.coreutils}/bin/cp"; }
      ];
    })
    (mkIf packages.zed.linkConfig (
      let
        settingsJson =
          with lib;
          toJSON (
            updateManyAttrsByPath [
              {
                path = [ "buffer_font_size" ];
                update = _: packages.zed.config.bufferFontSize;
              }
              {
                path = [ "ui_font_size" ];
                update = _: packages.zed.config.uiFontSize;
              }
              {
                path = [ "terminal" "font_size"];
                update = _: packages.zed.config.terminalFontSize;
              }
            ] (fromJSON (unsafeDiscardStringContext (readFile ../../config/zed/settings.json)))
          );
      in
      {
        home-manager.users.face.home.file = {
          ".config/zed/settings.json".text = settingsJson;
          ".config/zed/keymap.json".source = ../../config/zed/keymap.json;
        };
      }
    ))

  ];
}
