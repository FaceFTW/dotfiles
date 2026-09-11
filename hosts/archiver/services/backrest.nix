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

  modules.nginx.reverse-proxy.backrest = {
    localPort = 9898;
    serverName = "backrest.faceftw.dev";
  };
}
