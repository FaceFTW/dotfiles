{
  ...
}:
{
  ############################################
  # Linkwarden
  ############################################
  systemUser.linkwarden.home = "/mnt/motorway/var/linkwarden";

  services.linkwarden = {
    enable = true;
    user = "linkwarden";
    group = "linkwarden";

    port = 3015;
    openFirewall = true;

    cacheLocation = "/mnt/motorway/var/linkwarden/cache";
    storageLocation = "/mnt/motorway/var/linkwarden/data";
    secretFiles.NEXTAUTH_SECRET = "/run/secrets/linkwarden_nextauth_secret";
    secretFiles.POSTGRES_PASSWORD = "/run/secrets/linkwarden_postgres_password";
    enableRegistration = true;
  };

  # Nginx Reverse Proxy Config
   services.nginx. upstreams.linkwarden.servers."localhost:3015" = { };
    services.nginx.virtualHosts."linkwarden.faceftw.local" = {
    serverName = "linkwarden.faceftw.local";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    locations."/".proxyPass = "http://linkwarden";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
  };
}
