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
    extraConfig = ''
      include "/var/lib/secrets/dnskeys.conf";
    '';
    extraOptions = "";
    forwarders = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    listenOnPort = 1053;
    zones = [
      {
        name = "faceftw.home";
        file = "/etc/bind/zones/faceftw.home.zone";
        master = true;
        extraConfig = "allow-update { key rfc2136key.faceftw.home.; };";
      }
      {
        name = "internal.faceftw.dev";
        file = "/etc/bind/zones/internal.faceftw.dev.zone";
        master = true;
        extraConfig = ''
          allow-update { key rfc2136key.internal.faceftw.dev.; };
        '';
      }
    ];
  };

  environment.etc."bind/zones/faceftw.home.zone" = {
    enable = true;
    user = "named";
    group = "named";
    mode = "0644";
    text = ''
      $ORIGIN faceftw.home.
      $TTL    60   ; 86400 - 1 day

      @                   IN SOA  dns.faceftw.home. admin.faceftw.home. (
                            1337   ; Serial
                            3600   ; Refresh
                            300    ; Retry
                            3600   ; Expire
                            300)   ; Negative Cache TT

      @                   IN NS   dns.faceftw.home.

      router                 IN A      192.168.0.1

      durandal               IN A      192.168.0.7
      pihole                 IN A      192.168.0.7
      dns                    IN A      192.168.0.7

      port-authority         IN A      192.168.0.26

      fabricator             IN A      192.168.0.42

      archiver               IN A      192.168.0.172
      immich                 IN A      192.168.0.172
      actual                 IN A      192.168.0.172
      linkwarden             IN A      192.168.0.172
      backrest               IN A      192.168.0.172
      syncthing-archiver     IN A      192.168.0.172
      garage                 IN A      192.168.0.172
      s3.garage              IN A      192.168.0.172
      *.s3.garage            IN CNAME  s3.garage.faceftw.home.
      web.garage             IN A      192.168.0.172
      *.web.garage           IN CNAME  web.garage.faceftw.home.
      jellyfin               IN A      192.168.0.172
      navidrome              IN A      192.168.0.172
    '';
  };

  # TODO This should be moved to cloudflare, A records can point to local IPs
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
      port-authority         IN A      192.168.0.26
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

    garage = {
      apex = "garage";
      ipAddress = "192.168.0.172";
      additionalSubdomains = [
        "s3.garage"
        "web.garage"
      ];
      cnameRecords = [
        [
          "*.s3.garage"
          "s3.garage.faceftw.dev"
        ]
        [
          "*.web.garage"
          "web.garage.faceftw.dev"
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
