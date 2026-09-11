{
  ...
}:
{
  ############################################
  # Linkwarden
  ############################################
  modules.users.system.linkwarden.home = "/mnt/motorway/var/linkwarden";

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

  modules.nginx.reverse-proxy.linkwarden = {
    localPort = 3015;
    serverName = "linkwarden.faceftw.dev";
  };

}
