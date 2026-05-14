{
  pkgs,
  lib,
  ...
}:
{
  ############################################
  # Nginx
  ############################################
  services.nginx = {
    enable = true;

    upstreams.immich.servers."localhost:2283" = { };
    upstreams.syncthing-gui.servers."localhost:8384" = { };
    upstreams.linkwarden.servers."localhost:3015" = { };
    upstreams.backrest.servers."127.0.0.1:9898" = { };

    virtualHosts.immich = {
      serverName = "archiver";
      listen = [
        {
          addr = "0.0.0.0";
          port = 2284;
        }
        {
          addr = "[::0]";
          port = 2284;
        }
      ];

      extraConfig = "client_max_body_size 1g;";
      locations."/".proxyPass = "http://immich";
      locations."/".recommendedProxySettings = true;
      locations."/".proxyWebsockets = true;
    };

    virtualHosts.syncthing-gui = {
      serverName = "archiver";
      listen = [
        {
          addr = "0.0.0.0";
          port = 8385;
        }
        {
          addr = "[::0]";
          port = 8385;
        }
      ];

      extraConfig = ''
        proxy_set_header Host localhost; # https://docs.syncthing.net/users/faq.html#why-do-i-get-host-check-error-in-the-gui-api
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $hostname;
      '';
      locations."/".proxyPass = "http://syncthing-gui";
    };

    virtualHosts.linkwarden = {
      serverName = "archiver";
      listen = [
        {
          addr = "0.0.0.0";
          port = 3014;
        }
        {
          addr = "[::0]";
          port = 3014;
        }
      ];

      locations."/".proxyPass = "http://linkwarden";
      locations."/".recommendedProxySettings = true;
      locations."/".proxyWebsockets = true;
    };

    virtualHosts.backrest = {
      serverName = "archiver";
      listen = [
        {
          addr = "0.0.0.0";
          port = 9897;
        }
        {
          addr = "[::0]";
          port = 9897;
        }
      ];

      locations."/".proxyPass = "http://backrest";
      locations."/".recommendedProxySettings = true;
      locations."/".proxyWebsockets = true;
    };
  };

}
