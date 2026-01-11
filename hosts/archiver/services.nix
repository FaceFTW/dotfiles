{ pkgs, ... }:
{
  users.users.watchman = {
    isSystemUser = true;
    group = "watchman";
    createHome = false;
  };
  users.groups.watchman = { };

  # services.nginx = {
  #   enable = true;
  #   config = ''
  #     error_log stderr info;
  #     events { }
  #     http {
  #         # Load mime types and configure maximum size of the types hash tables.
  #         include ${pkgs.nginx}/conf/mime.types;
  #         types_hash_max_size 2688;
  #         default_type application/octet-stream;
  #         ssl_protocols TLSv1.2 TLSv1.3;
  #         ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
  #         # $connection_upgrade is used for websocket proxying
  #         map $http_upgrade $connection_upgrade {
  #             default upgrade;
  #             '''      close;
  #         }
  #         client_max_body_size 10m;
  #         server_tokens off;

  #         upstream nix-cache {
  #             server localhost:5000 ;
  #         }

  #         server {
  #             listen 0.0.0.0:80 ;
  #             listen [::0]:80 ;
  #             server_name archiver;
  #             location ~ ^/(nix-cache)/ {
  #                 rewrite ^/nix-cache/(.*) /$1 break;
  #                 proxy_pass http://nix-cache;
  #                 proxy_redirect off;
  #                 proxy_http_version 1.1;
  #                 proxy_set_header Upgrade $http_upgrade;
  #                 proxy_set_header Connection $connection_upgrade;
  #                 proxy_set_header Host $host;
  #                 proxy_set_header X-Real-IP $remote_addr;
  #                 proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #             }
  #         }
  #     }
  #   '';
  # };

  # services.logrotate.settings.nginx = {
  #   files = [ "/var/log/nginx/*.log" ];
  #   frequency = "weekly";
  #   rotate = 26;
  #   compress = true;
  #   delaycompress = true;
  #   postrotate = "[ ! -f /var/run/nginx/nginx.pid ] || kill -USR1 `cat /var/run/nginx/nginx.pid`";
  # };

  services.smartd.enable = true;
  services.smartd.defaults.monitored = "-a -m <nomailer> -M exec ${pkgs.smartd-notif-event}/bin/smartd-notif-event -s (S/../.././03|L/../(2|4)/./04)";

  systemd.services.ugreen-led-mons = {
    wantedBy = [ "sysinit.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.ugreen-led-mon}/bin/ugreen-led-mon";
  };

  systemd.timers."archive-offline-mirror" = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "weekly";
    timerConfig.Persistent = true;
  };
  systemd.services."archive-offline-mirror" = {
    wants = [
      "mnt-archive.mount"
      "mnt-freeman.mount"
    ];
    serviceConfig.Type = "oneshot";
    script = ''

      token=$(cat /run/secrets/pushover_api_key)
      user=$(cat /run/secrets/pushover_user_key)

      ${pkgs.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
        --form-string "title="Archive Offline Mirror" \
        --form-string "message=Starting backup job" \
        https://api.pushover.net/1/messages.json


      ${pkgs.rsync}/bin/rsync -aPt \
          --archive \
          --partial \
          --progress \
          --delete-before \
          --exclude /SteamBackups
          --exclude /Misc_Large
          --exclude /SteamLibrary
          /mnt/archive/ \
          /mnt/freeman

      ${pkgs.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
        --form-string "title="Archive Offline Mirror" \
        --form-string "message=Backup Job completed. Check logs for more info" \
        https://api.pushover.net/1/messages.json
    '';
  };


}
