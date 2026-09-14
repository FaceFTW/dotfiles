{
  ...
}:
{
  ####################################
  # Self-hosted DNS for ACME
  ####################################

  system.activationScripts.bind-zones.text = ''
    mkdir -p /etc/bind/zones
    chown -R named:named /etc/bind
  '';

  services.bind = {
    enable = true;
    checkConfig = false;
    forwarders = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    listenOnPort = 1053;
    zones = [
      {
        name = "internal.faceftw.dev";
        file = "/etc/bind/zones/internal.faceftw.dev.zone";
        master = true;
      }
    ];
  };

  environment.etc."bind/zones/internal.faceftw.dev.zone" = {
    enable = true;
    user = "named";
    group = "named";
    mode = "0644";
    text = ''
      $ORIGIN internal.faceftw.dev.
      $TTL    60   ; 86400 - 1 day

      @                   IN SOA  dns-internal.faceftw.dev. admin.internal.faceftw.dev. (
                            20260902    ; Serial
                            3600        ; Refresh
                            300         ; Retry
                            3600        ; Expire
                            300)        ; Negative Cache TT

      @                      IN NS   dns-internal.faceftw.dev.

      router                 IN A      192.168.0.1
      durandal               IN A      192.168.0.7
      fabricator             IN A      192.168.0.42
      archiver               IN A      192.168.0.172
    '';
  };

  modules.services.bind-zone = {
    dns-internal = {
      apex = "dns-internal";
      ipAddress = "192.168.0.7";
    };

    actual = {
      apex = "actual";
      ipAddress = "192.168.0.172";
    };

    backrest = {
      apex = "backrest";
      ipAddress = "192.168.0.172";
    };

    garage-s3 = {
      apex = "garage-s3";
      ipAddress = "192.168.0.172";
      cnameRecords = [
        [
          "*"
          "garage-s3.faceftw.dev"
        ]
      ];
    };

    garage-web = {
      apex = "garage-web";
      ipAddress = "192.168.0.172";
      cnameRecords = [
        [
          "*"
          "garage-web.faceftw.dev"
        ]
      ];
    };

    immich = {
      apex = "immich";
      ipAddress = "192.168.0.172";
    };

    jellyfin = {
      apex = "jellyfin";
      ipAddress = "192.168.0.172";
    };

    linkwarden = {
      apex = "linkwarden";
      ipAddress = "192.168.0.172";
    };

    navidrome = {
      apex = "navidrome";
      ipAddress = "192.168.0.172";
    };

    pihole = {
      apex = "pihole";
      ipAddress = "192.168.0.7";
    };

    syncthing-archiver = {
      apex = "syncthing-archiver";
      ipAddress = "192.168.0.172";
    };

  };

}
