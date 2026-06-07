{
  pkgs,
  ...
}:
{
  ############################################
  # Nix Binary Cache (S3 via Garage)
  ############################################
  systemUser.garage.home = "/mnt/motorway/var/garage";
  services.garage.enable = true;
  services.garage.settings = {
    data_dir = "/mnt/motorway/var/garage/data";
    metadata_dir = "/mnt/motorway/var/garage/metadata";

    replication_factor = 1;

    rpc_bind_addr = "[::]:3901";
    rpc_public_addr = "localhost:3901";
    rpc_secret_file = "/run/secrets/garage_rpc_secret";

    s3_api.s3_region = "archiver";
    s3_api.api_bind_addr = "[::]:3900";
    s3_api.root_domain = ".s3.garage.faceftw.local";

    s3_web.bind_addr = "[::]:3902";
    s3_web.root_domain = ".web.garage.faceftw.local";
    index = "index.html";

    k2v_api.api_bind_addr = "[::]:3904";

    admin.api_bind_addr = "[::]:3903";
    admin.admin_token_file = "/run/secrets/garage_admin_token";
    admin.metrics_token_file = "/run/secrets/garage_metrics_token";
  };
  services.garage.package = pkgs.garage_2;

  # Nginx Reverse Proxy Config - S3
  services.nginx.upstreams.garage-s3.servers."127.0.0.1:3900" = { };
  services.nginx.virtualHosts."s3.garage.faceftw.local" = {
    serverName = "s3.garage.faceftw.local *.s3.garage.faceftw.local";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    locations."/".proxyPass = "http://garage-s3";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
    extraConfig = ''
      chunked_transfer_encoding off;
      client_max_body_size 4g;
    '';
  };

  # Nginx Reverse Proxy Config - Web bucket
  services.nginx.upstreams.garage-web.servers."127.0.0.1:3902" = { };
  services.nginx.virtualHosts."web.garage.faceftw.local" = {
    serverName = "web.garage.faceftw.local *.web.garage.faceftw.local";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    locations."/".proxyPass = "http://garage-web";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
    extraConfig = ''
      chunked_transfer_encoding off;
    '';
  };

  ############################################
  # Garage Web UI
  ############################################
  systemd.services.garage-web-ui = {
    wantedBy = [
      "default.target"
    ];
    after = [
      "network.target"
      "garage.service"
    ];
    wants = [
      "garage.service"
    ];

    environment.PORT = "3919";
    environment.CONFIG_PATH = "/etc/garage.toml";
    environment.API_ADMIN_KEY_FILE = "%d/GARAGE_ADMIN_TOKEN";

    serviceConfig.LoadCredential = [ "GARAGE_ADMIN_TOKEN:/run/secrets/garage_admin_token" ];
    serviceConfig.User = "garage";
    serviceConfig.Group = "garage";
    serviceConfig.ExecStart = "${pkgs.garage-webui}/bin/garage-webui";
  };

  # Nginx Reverse Proxy Config
  services.nginx.upstreams.garage-ui.servers."127.0.0.1:3919" = { };
  services.nginx.virtualHosts."garage.faceftw.local" = {
    serverName = "garage.faceftw.local";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    locations."/".proxyPass = "http://garage-ui";
    locations."/".recommendedProxySettings = true;
    locations."/".proxyWebsockets = true;
  };
}
