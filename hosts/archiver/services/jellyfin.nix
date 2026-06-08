{
  ...
}:
{
  ############################################
  # Jellyfin
  ############################################
  modules.users.system.jellyfin.home = "/mnt/motorway/var/jellyfin";

  services.jellyfin = {
    enable = true;
    cacheDir = "/mnt/motorway/var/jellyfin/cache";
    configDir = "/mnt/motorway/var/jellyfin/config";
    dataDir = "/mnt/motorway/var/jellyfin/data";
    logDir = "/mnt/motorway/var/jellyfin/logs";
    openFirewall = true;
    user = "jellyfin";
    group = "jellyfin";
  };
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

  # Nginx Reverse Proxy Config
   services.nginx. upstreams.jellyfin.servers."127.0.0.1:8096" = { };
    services.nginx.virtualHosts."jellyfin.faceftw.local" = {
    serverName = "jellyfin.faceftw.local";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    locations."/".proxyPass = "http://jellyfin";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
  };
}
