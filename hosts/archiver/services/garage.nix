{
  pkgs,
  ...
}:
{
  ############################################
  # Nix Binary Cache (S3 via Garage)
  ############################################
  modules.users.system.garage.home = "/mnt/motorway/var/garage";
  services.garage.enable = true;
  services.garage.settings = {
    data_dir = "/mnt/motorway/var/garage/data";
    metadata_dir = "/mnt/motorway/var/garage/metadata";

    replication_factor = 1;

    rpc_bind_addr = "[::]:3901";
    rpc_public_addr = "localhost:3901";
    rpc_secret_file = "/run/secrets/garage_rpc_secret";

    s3_api.s3_region = "us-east-1";
    s3_api.api_bind_addr = "[::]:3900";
    s3_api.root_domain = "garage-s3.faceftw.dev";

    s3_web.bind_addr = "[::]:3902";
    s3_web.root_domain = "garage-web.faceftw.dev";
    index = "index.html";

    k2v_api.api_bind_addr = "[::]:3904";

    admin.api_bind_addr = "[::]:3903";
    admin.admin_token_file = "/run/secrets/garage_admin_token";
    admin.metrics_token_file = "/run/secrets/garage_metrics_token";
  };
  services.garage.package = pkgs.garage_2;

  modules.nginx.reverse-proxy.garage-s3 = {
    localPort = 3900;
    serverName = "garage-s3.faceftw.dev";
    additionalServerNames = [ "*.garage-s3.faceftw.dev" ];
    extraConfig = ''
      chunked_transfer_encoding off;
      client_max_body_size 4g;
    '';
  };

  modules.nginx.reverse-proxy.garage-web = {
    localPort = 3902;
    serverName = "garage-web.faceftw.dev";
    additionalServerNames = [ "*.garage-web.faceftw.dev" ];
    extraConfig = ''
      chunked_transfer_encoding off;
      client_max_body_size 4g;
    '';
  };
}
