{
  config,
  ...
}:
{
  ############################################
  # Immich
  ############################################
  modules.users.system.immich.home = "/mnt/motorway/var/immich";

  services.immich = {
    enable = true;
    user = "immich";
    group = "immich";

    openFirewall = true;
    secretsFile = config.sops.secrets.immich_secrets.path;
    mediaLocation = "/mnt/motorway/var/immich/data";
    database.enable = true;
  };

  modules.nginx.reverse-proxy.immich = {
    localPort = 2283;
    serverName = "immich.faceftw.dev";
    extraConfig = "client_max_body_size 1g;";
  };

}
