{
  config,
  pkgs,
  lib,
  ...
}:
let
  node = config.packages.nodejs.node;
  vscodePatch = config.packages.nodejs.vscodeRemotePatch;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.packages.nodejs.node = mkEnableOption "NodeJS";
  options.packages.nodejs.vsCodeRemotePatch = mkEnableOption "VS Code Remote Server Patch";

  config = {
    assertions = [
      {
        assertion = !vscodePatch || (vscodePatch && node);
        message = "VS Code Remote Server Patch requires Node!";
      }
    ];

    environment.systemPackages = mkIf node [
      pkgs.nodejs_24
    ];

    systemd.user.paths.vscode-remote-workaround = mkIf vscodePatch {
      wantedBy = [ "default.target" ];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
      script = mkIf vscodePatch ''
        for i in ~/.vscode-server/bin/*; do
          echo "Fixing vscode-server in $i..."
          ln -sf ${pkgs.nodejs_24}/bin/node $i/node
        done
      '';
    };
  };
}
