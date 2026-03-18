{
  config,
  pkgs,
  lib,
  ...
}:
let
  nodejs = config.packages.nodejs;

  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.packages.nodejs.node = mkEnableOption "NodeJS";
  options.packages.nodejs.vsCodeRemotePatch = mkEnableOption "VS Code Remote Server Patch";
  options.packages.nodejs.biome = mkEnableOption "Install Biome";

  config = mkMerge [
    ############################################
    # Module Assertions
    ############################################
    {
      assertions = [
        {
          assertion = !nodejs.vsCodeRemotePatch || (nodejs.vsCodeRemotePatch && nodejs.node);
          message = "VS Code Remote Server Patch requires Node!";
        }
      ];
    }
    ############################################
    # NodeJS
    ############################################
    (mkIf nodejs.node {
      environment.systemPackages = [
        pkgs.nodejs_24
      ];
    })
    ############################################
    # Biome
    ############################################
    (mkIf nodejs.biome {
      environment.systemPackages = [
        pkgs.biome
      ];
    })
    ############################################
    # VS Code Remote Server Patch
    ############################################
    (mkIf nodejs.vsCodeRemotePatch {
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
