{
  config,
  pkgs,
  lib,
  ...
}:
let
  node = config.packages.nodejs.node;
  vscodePatch = config.packages.nodejs.vsCodeRemotePatch;
  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.packages.nodejs.node = mkEnableOption "NodeJS";
  options.packages.nodejs.vsCodeRemotePatch = mkEnableOption "VS Code Remote Server Patch";

  config = mkMerge [
    ############################################
    # Module Assertions
    ############################################
    {
      assertions = [
        {
          assertion = !vscodePatch || (vscodePatch && node);
          message = "VS Code Remote Server Patch requires Node!";
        }
      ];
    }
    ############################################
    # NodeJS
    ############################################
    (mkIf node {
      environment.systemPackages = [
        pkgs.nodejs_24
      ];
    })
    ############################################
    # VS Code Remote Server Patch
    ############################################
    (mkIf vscodePatch {
      systemd.user.paths.vscode-remote-workaround = {
        wantedBy = [ "default.target" ];
        pathConfig.PathChanged = "%h/.vscode-server/bin";
      };

      systemd.user.services.vscode-remote-workaround.script = ''
        for i in ~/.vscode-server/bin/*; do
          echo "Fixing vscode-server in $i..."
          ln -sf /run/current-system/sw/bin/node $i/node
        done
      '';
    })
  ];
}
