{
  pkgs,
  ...
}:
{
  ############################################
  # Mainsail + Nginx Config
  ############################################
  services.nginx = {
    enable = true;
    user = "klipper";
    group = "klipper";

    upstreams.mainsail-apiserver.servers."127.0.0.1:7125" = { };
    upstreams.webcam-server.servers."127.0.0.1:5123" = { };

    virtualHosts.ingress = {
      serverName = "fabricator";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
        {
          addr = "[::0]";
          port = 80;
        }
      ];
      extraConfig = ''
        index index.html;
        client_max_body_size 1g;
      '';

      root = "${pkgs.mainsail}/share/mainsail";

      locations."/".tryFiles = "$uri $uri/ /index.html";

      locations."/index.html".extraConfig =
        "add_header Cache-Control \"no-store, no-cache, must-revalidate\";";

      locations."/websocket".proxyPass = "http://mainsail-apiserver/websocket";
      locations."/websocket".recommendedProxySettings = true;
      locations."/websocket".proxyWebsockets = true;

      locations."~ ^/(webcam)".proxyPass = "http://webcam-server$request_uri";
      locations."~ ^/(webcam)".recommendedProxySettings = true;
      locations."~ ^/(webcam)".proxyWebsockets = true;

      locations."~ ^/(printer|api|access|machine|server)/".proxyPass =
        "http://mainsail-apiserver$request_uri";
      locations."~ ^/(printer|api|access|machine|server)/".recommendedProxySettings = true;
      locations."~ ^/(printer|api|access|machine|server)/".proxyWebsockets = true;
    };
  };
}
