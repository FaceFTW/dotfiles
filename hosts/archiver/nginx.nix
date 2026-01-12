{ pkgs, ... }:
{
  services.nginx = {
    enable = true;
    config = ''
      error_log stderr info;
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

          upstream photoprism {
              server localhost:2283 ;
          }

          server {
              listen 0.0.0.0:80 ;
              listen [::0]:80 ;
              server_name archiver;
              location ~ ^/(photoprism)/ {
                  rewrite ^/photoprism/(.*) /$1 break;
                  proxy_pass http://photoprism;
                  proxy_redirect off;
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
    rotate = 26;
    compress = true;
    delaycompress = true;
    postrotate = "[ ! -f /var/run/nginx/nginx.pid ] || kill -USR1 `cat /var/run/nginx/nginx.pid`";
  };
}
