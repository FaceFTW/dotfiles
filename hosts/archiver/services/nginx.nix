{
  ...
}:
{
  ############################################
  # Nginx
  ############################################
  services.nginx = {
    enable = true;

    upstreams.immich.servers."localhost:2283" = { };

    virtualHosts."immich.faceftw.local" = {
      # enableACME = true;
      # forceSSL = true;

      serverName = "immich.faceftw.local";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];

      extraConfig = "client_max_body_size 1g;";
      locations."/".proxyPass = "http://immich";
      locations."/".recommendedProxySettings = true;
      locations."/".proxyWebsockets = true;
    };

    upstreams.syncthing-gui.servers."localhost:8384" = { };
    virtualHosts."syncthing.archiver.faceftw.local" = {
      serverName = "archiver";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
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

    upstreams.linkwarden.servers."localhost:3015" = { };
    virtualHosts."linkwarden.faceftw.local" = {
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

    upstreams.backrest.servers."127.0.0.1:9898" = { };
    virtualHosts."backrest.faceftw.local" = {
      serverName = "backrest.faceftw.local";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];

      locations."/".proxyPass = "http://backrest";
      locations."/".recommendedProxySettings = true;
      locations."/".proxyWebsockets = true;
    };

    upstreams.navidrome.servers."127.0.0.1:4533" = { };
    virtualHosts."navidrome.faceftw.local" = {
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

    upstreams.jellyfin.servers."127.0.0.1:8096" = { };
    virtualHosts."jellyfin.faceftw.local" = {
      serverName = "jellyfin.faceftw.local";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];

      locations."/".proxyPass = "http://jellyfin";
      locations."/".recommendedProxySettings = true;
      locations."/".proxyWebsockets = true;
    };
  };

}
