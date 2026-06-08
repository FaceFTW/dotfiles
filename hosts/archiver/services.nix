{
  pkgs,
  ...
}:
{
  imports = [
    ./services/backrest.nix
    ./services/garage.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/linkwarden.nix
    ./services/mirror_jobs.nix
    ./services/navidrome.nix
    ./services/syncthing.nix
  ];

  services.nginx.enable = true;

  services.smartd.enable = true;
  services.smartd.defaults.monitored = "-a -m <nomailer> -M exec ${pkgs.smartd-notif-event}/bin/smartd-notif-event -s (S/../.././03|L/../(2|4)/./04)";

  systemd.services.ugreen-led-mons = {
    wantedBy = [ "sysinit.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.ugreen-led-mon}/bin/ugreen-led-mon";
  };

  # Autostart btop monitor as a kiosk
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "${pkgs.btop}/bin/btop --config /home/face/.config/btop/btop.conf --preset 1 --force-utf --no-tty"
    ];
    serviceConfig.User = "face"; # this is unconventional
    serviceConfig.Group = "users";
  };

  ############################################
  # SSH Server
  ############################################
  servicesCustom.ssh-server.enable = true;
  servicesCustom.ssh-server.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuQw4U+Wam1gjuEXyH/cObZfnfYiA/LPF0kjQPFTz9x face@manifold-wsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3fuhneqp6s6Ye9hHb60QrXq8vlu5INzeKlgiPtO5Pq alex@faceftw.dev"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWujFooZO+HsXm4hRgrhqlntUMQrBiSixgwC70bzE96 face@nemesis"
  ];

  ############################################
  # Postgres (Shared)
  ############################################
  modules.users.system.postgres.home = "/mnt/motorway/var/postgres";
  services.postgresql.dataDir = "/mnt/motorway/var/postgres";
  services.postgresql.settings.max_connections = 200;

}
