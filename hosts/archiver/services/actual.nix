{
  ...
}:
{
  ############################################
  # Actual
  ############################################
  modules.users.system.actual.home = "/mnt/motorway/var/actual";

  services.actual = {
    enable = true;
    settings.dataDir = "/mnt/motorway/var/actual/data";
    settings.port = 3012;
  };

  # Nginx Reverse Proxy Config
  services.nginx.upstreams.actual.servers."localhost:3012" = { };
  services.nginx.virtualHosts."actual.faceftw.dev" = {
    forceSSL = true;
    # enableACME = true;
    useACMEHost = "faceftw.dev";

    serverName = "actual.faceftw.dev";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
    ];

    extraConfig = "client_max_body_size 1g;";
    locations."/".proxyPass = "http://actual";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
  };
}
