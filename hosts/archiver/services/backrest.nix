{
  ...
}:
{
  ############################################
  # Backrest
  ############################################
  modules.users.system.backrest.home = "/mnt/motorway/var/backrest";

  modules.services.backrest = {
    enable = true;
    configPath = "/mnt/motorway/var/backrest/config.json";
    dataDir = "/mnt/motorway/var/backrest/data";
    cacheDir = "/mnt/motorway/var/backrest/cache";
    user = "backrest";
    group = "backrest";
  };

  # Nginx Reverse Proxy Config
    services.nginx.upstreams.backrest.servers."127.0.0.1:9898" = { };
    services.nginx.virtualHosts."backrest.internal.faceftw.dev" = {
    serverName = "backrest.internal.faceftw.dev";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    locations."/".proxyPass = "http://backrest";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
  };
}
