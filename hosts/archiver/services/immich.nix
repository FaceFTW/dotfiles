{
  config,
  ...
}:
{
  ############################################
  # Immich
  ############################################
  systemUser.immich.home = "/mnt/motorway/var/immich";

  services.immich = {
    enable = true;
    user = "immich";
    group = "immich";

    openFirewall = true;
    secretsFile = config.sops.secrets.immich_secrets.path;
    mediaLocation = "/mnt/motorway/var/immich/data";
    database.enable = true;
  };

  # Nginx Reverse Proxy Config
    services.nginx.upstreams.immich.servers."localhost:2283" = { };
    services.nginx.virtualHosts."immich.faceftw.local" = {
    # enableACME = true;
    # forceSSL = true;

    serverName = "immich.faceftw.local";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    extraConfig = "client_max_body_size 1g;";
    locations."/".proxyPass = "http://immich";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
  };

}
