{
  pkgs,
  lib,
  ...
}:
{
  users.users.klipper = {
    isSystemUser = true;
    group = "klipper";
    createHome = false;
  };
  users.groups.klipper = { };

  environment.systemPackages = [ pkgs.klipperscreen ];

  services.klipper.enable = true;
  services.klipper.user = "klipper";
  services.klipper.group = "klipper";
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
  # Webcam Daemon
  ############################################
  systemd.services.webcamd = {
    enable = true;
    description = "Webcam Stream Daemon";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    serviceConfig.ExecStart = (
      builtins.foldl' (acc: e: acc + " " + e) "" [
        "${pkgs.libcamera}/bin/libcamerify"
        "${pkgs.ustreamer}/bin/ustreamer"
        "--device=/dev/video0"
        "--format=uyvy"
        "--encoder=M2M-VIDEO"
        "--resolution=1280x720"
        "--allow-origin=http://localhost:*"
        "--host=0.0.0.0"
        "--port=5123"
        "--verbose"
      ]
    );

    serviceConfig.User = "klipper";
    serviceConfig.Group = "klipper";
    serviceConfig.SupplementaryGroups = [ "camera" ];
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
      error_log stderr;
      events { }
      http {
          # Load mime types and configure maximum size of the types hash tables.
          include ${pkgs.nginx}/conf/mime.types;
          types_hash_max_size 2688;
          default_type application/octet-stream;
          ssl_protocols TLSv1.2 TLSv1.3;
          ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
          # $connection_upgrade is used for websocket proxying
          map $http_upgrade $connection_upgrade {
              default upgrade;
              '''      close;
          }
          client_max_body_size 10m;
          server_tokens off;

          upstream mainsail-apiserver {
              server 127.0.0.1:7125 ;
          }
          upstream webcam-server {
              server 127.0.0.1:5123 ;
          }

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
              location ~ ^/(webcam)/ {
                  proxy_pass http://webcam-server$request_uri;
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
  };

  services.logrotate.settings.nginx = {
    files = [ "/var/log/nginx/*.log" ];
    frequency = "weekly";
    su = "klipper klipper";
    rotate = 26;
    compress = true;
    delaycompress = true;
    postrotate = "[ ! -f /var/run/nginx/nginx.pid ] || kill -USR1 `cat /var/run/nginx/nginx.pid`";
  };
}
