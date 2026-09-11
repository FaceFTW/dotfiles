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

  modules.nginx.reverse-proxy.jellyfin = {
    localPort = 8096;
    serverName = "jellyfin.faceftw.dev";
  };
}
