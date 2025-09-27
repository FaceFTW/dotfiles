{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.gnupg.agent.enable = false; # Using GPG forwarding from Windows seen below
  systemd.user.services.win-gpg-forwarder.enable = true;
  systemd.user.services.win-gpg-forwarder.path = [
    pkgs.socat
    pkgs.gnupg
  ];
  systemd.user.services.win-gpg-forwarder.wantedBy = [ "default.target" ];
  systemd.user.services.win-gpg-forwarder.preStart = ''
    	mkdir /run/user/1000/gnupg
  '';
  systemd.user.services.win-gpg-forwarder.script = ''

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
  # systemd.user.services.win-gpg-forwarder.postStop = ''rm -f /run/user/1000/gnupg/S.gpg-agent'';
}