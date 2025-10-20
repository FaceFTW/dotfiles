{
  pkgs,
  lib,
  ...
}:
{
  services.klipper.enable = true;
  services.klipper.firmwares.fabricator.enable = true;
  services.klipper.firmwares.fabricator.configFile = ./klipper/Kconfig;
  services.klipper.firmwares.fabricator.serial =
    /dev/serial/by-id/usb-Klipper_stm32g0b0xx_36004C0001504E5238363120-if00;
  services.klipper.configFile = ./klipper/printer.cfg;

  ############################################
  # Moonraker Config
  ############################################
  environment.etc."moonraker.cfg".source = ./klipper/moonraker.cfg;

  systemd.tmpfiles.rules = [
    "d '/var/lib/moonraker' - klipper klipper - -"
    "d '/var/lib/moonraker/tools/klipper_estimator' - klipper klipper - -"
    "L+ '/var/lib/moonraker/tools/klipper_estimator/klipper_estimator_linux' - - - - ${lib.getExe pkgs.klipper-estimator}"
  ];

  systemd.services.moonraker = {
    description = "Moonraker, an API web server for Klipper";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "klipper.service"
      "moonraker-key-setup.service"
    ];

    # Moonraker really wants its own config to be writable...
    script = ''
      config_path="/var/lib/moonraker/config/moonraker-temp.cfg"
      mkdir -p $(dirname "$config_path")
      cp /etc/moonraker.cfg "$config_path"
      chmod u+w "$config_path"
      exec ${pkgs.moonraker}/bin/moonraker -d /var/lib/moonraker -c "$config_path"
    '';

    # Needs `ip` command
    path = [ pkgs.iproute2 ];

    serviceConfig.WorkingDirectory = /var/lib/moonraker;
    serviceConfig.PrivateTmp = true;
    serviceConfig.Group = "klipper";
    serviceConfig.User = "klipper";
  };

  systemd.services.moonraker-key-setup = {
    description = "Initializes pre-generated Moonraker API Key";
    wantedBy = [ "multi-user.target" ];
    before = [ "moonraker.service" ];
    path = [ pkgs.moonrakerSopsApiKey ];

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.moonrakerSopsApiKey}/bin/provisionMoonrakerKey";
  };

  ############################################
  # Mainsail + Nginx Config
  ############################################
  services.nginx = {
    enable = true;
    user = "klipper";
    group = "klipper";
    # modules = [ pkgs.nginxModules.lua ];
    # Manual config because I need to do some _wacky shit_
    config = ''
    # pid /run/nginx/nginx.pid;
    error_log stderr;
    # daemon off;
    events{
    }
    http {
        # Load mime types and configure maximum size of the types hash tables.
        # include ${pkgs.nginx}/conf/mime.types;
        types_hash_max_size 2688;
        # include ${pkgs.nginx}/conf/fastcgi.conf;
        # include ${pkgs.nginx}/conf/uwsgi_params;
        default_type application/octet-stream;
        upstream mainsail-apiserver {
            server 127.0.0.1:7125 ;
        }
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
        # $connection_upgrade is used for websocket proxying
        map $http_upgrade $connection_upgrade {
            default upgrade;
            '''      close;
        }
        client_max_body_size 10m;
        server_tokens off;
        server {
            listen 0.0.0.0:80 ;
            listen [::0]:80 ;
            root ${pkgs.mainsail}/share/mainsail;
            index index.html;
            server_name fabricator;
            location / {
                try_files $uri $uri/ /index.html;
            }
            location /index.html {
                add_header Cache-Control "no-store, no-cache, must-revalidate";
            }
            location /websocket {
                proxy_pass http://mainsail-apiserver/websocket;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_read_timeout 86400;
            }
            location ~ ^/(printer|api|access|machine|server)/ {
                proxy_pass http://mainsail-apiserver$request_uri;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            }
        }
    }
    '';

    # upstreams.mainsail-apiserver.servers."127.0.0.1:7125" = { };
    # virtualHosts."fabricator" = {
    #   root = lib.mkForce "${pkgs.mainsail}/share/mainsail";
    #   locations = {
    #     "/" = {
    #       index = "index.html";
    #       tryFiles = "$uri $uri/ /index.html";
    #     };
    #     "/index.html".extraConfig = ''
    #       add_header Cache-Control "no-store, no-cache, must-revalidate";
    #     '';
    #     "/websocket" = {
    #       proxyWebsockets = true;
    #       proxyPass = "http://mainsail-apiserver/websocket";
    #     };
    #     "~ ^/(printer|api|access|machine|server)/" = {
    #       proxyWebsockets = true;
    #       proxyPass = "http://mainsail-apiserver$request_uri";
    #     };
    #   };
    # };
  };
}
