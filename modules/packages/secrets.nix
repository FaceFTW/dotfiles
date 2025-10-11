{
  config,
  pkgs,
  lib,
  ...
}:
let
  secretsBase = config.packages.secrets.base;
  wslForwarding = config.packages.secrets.wslGpgForwarding;
  inherit (lib) mkIf mkEnableOption mkMerge;
in
{
  imports = [ ];

  options.packages.secrets.base = mkEnableOption "Secrets Management Utilities";
  options.packages.secrets.wslGpgForwarding = mkEnableOption "Use Windows GPG Agent Socket from WSL";

  config = mkMerge [
    ############################################
    # Module Assertions
    ############################################
    {
      assertions = [
        {
          assertion = (!wslForwarding || (secretsBase && wslForwarding));
          message = "WSL GPG Forwarding requires Baseline Secrets packages to be available";
        }
      ];
    }

    ############################################
    # Secrets Management Base Packages
    ############################################
    (mkIf secretsBase {
      environment.systemPackages = [
        pkgs.gnupg
        pkgs.sops
        pkgs.ssh-to-age
        pkgs.pinentry-curses
      ];
    })

    ############################################
    # WSL GPG Agent Forwarding
    ############################################
    (mkIf wslForwarding {
      environment.systemPackages = [
        pkgs.socat
      ];

      programs.gnupg.agent.enable = false;

      systemd.user.services.win-gpg-forwarder = {
        enable = true;
        path = [
          pkgs.socat
          pkgs.gnupg
        ];
        wantedBy = [ "default.target" ];
        preStart = "mkdir /run/user/1000/gnupg";
        script = ''
          #!/bin/bash
          # Launches socat+npiperelay to relay the gpg-agent socket file for use in WSL
          # Modified to work within the whole NixOS system
          # See https://justyn.io/blog/using-a-yubikey-for-gpg-in-windows-10-wsl-windows-subsystem-for-linux/ for details

          rm -f "$(gpgconf --list-dir agent-socket)"
          SOCKET_PATH="$(gpgconf --list-dir agent-socket)"

          # Relay the regular gpg-agent socket for gpg operations
          socat UNIX-LISTEN:"''${SOCKET_PATH},fork" EXEC:"/mnt/c/Users/awest/.local/bin/npiperelay.exe -ep -ei -s -a 'C:/Users/awest/AppData/Local/gnupg/S.gpg-agent'",nofork &
          AGENTPID=$!

          wait ''${AGENTPID}
        '';
      };
    })
  ];
}
