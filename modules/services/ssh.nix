{
  config,
  pkgs,
  lib,
  ...
}:
let
  services-custom = config.services-custom;
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

in
{
  options.services-custom.ssh-server = {
    enable = mkEnableOption "Enable SSH Server";

    authorizedKeys = mkOption {
      type = types.listOf types.str;
      description = "Public Keys that should be allowed to authenticate with the face user";
      default = [ ];
    };
  };

  config = mkIf services-custom.ssh-server.enable {
    # Some settings derived from: https://infosec.mozilla.org/guidelines/openssh
    services.openssh.enable = true;

    services.openssh.settings.AuthenticationMethods = "publickey";
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.KbdInteractiveAuthentication = false;
    services.openssh.settings.PermitRootLogin = "no";
    services.openssh.settings.AllowUsers = [ "face" ];

    services.openssh.settings.KexAlgorithms = [
      "sntrup761x25519-sha512"
      "mlkem768x25519-sha256"
      "curve25519-sha256@libssh.org"
      "ecdh-sha2-nistp521"
      "ecdh-sha2-nistp384"
      "ecdh-sha2-nistp256"
      "diffie-hellman-group-exchange-sha256"
    ];
    services.openssh.settings.Ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes128-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];
    services.openssh.settings.Macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
      "hmac-sha2-512"
      "hmac-sha2-256"
      "umac-128@openssh.com"
    ];

    services.openssh.settings.ClientAliveCountMax = 0;
    services.openssh.settings.ClientAliveInterval = 1500;

    services.openssh.settings.MaxSessions = 4;
    services.openssh.settings.Protocol = 2;

    services.openssh.settings.LogLevel = "VERBOSE";
    services.openssh.settings.Subsystem = "sftp ${pkgs.openssh}/libexec/sftp-server -f AUTHPRIV -l INFO";

    users.users.face.openssh.authorizedKeys.keys = services-custom.ssh-server.authorizedKeys;
  };

}
