{
  ...
}:
{
  ############################################
  # Navidrome
  ############################################
  services.navidrome = {
    enable = true;
    user = "face"; # Don't feel like dealing with ACLs
    group = "users";
    openFirewall = true;
    settings = {
      MusicFolder = "/mnt/archive/musik";
      DataFolder = "/mnt/archive/musik/navidrome";
    };
    environmentFile = "/run/secrets/navidrome";
  };

  modules.nginx.reverse-proxy.navidrome = {
    localPort = 4533;
    serverName = "navidrome.faceftw.dev";
  };
}
