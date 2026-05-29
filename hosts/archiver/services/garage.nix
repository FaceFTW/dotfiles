{
  config,
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
}
