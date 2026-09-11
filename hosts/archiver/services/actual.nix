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

  modules.nginx.reverse-proxy.actual = {
    localPort = 3012;
    serverName = "actual.faceftw.dev";
  };

}
