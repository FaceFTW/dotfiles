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

  # Nginx Reverse Proxy Config
  services.nginx.upstreams.navidrome.servers."127.0.0.1:4533" = { };
  services.nginx.virtualHosts."navidrome.faceftw.local" = {
    serverName = "navidrome.faceftw.local";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    locations."/".proxyPass = "http://navidrome";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
  };
}
