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
        name = "faceftw.local";
        file = "/etc/bind/zones/faceftw.local.zone";
        master = true;
        extraConfig = "allow-update { key rfc2136key.faceftw.local.; };";
      }
    ];
  };

  environment.etc."bind/zones/faceftw.local.zone" = {
    enable = true;
    user = "named";
    group = "named";
    mode = "0644";
    text = ''
      $ORIGIN faceftw.local.
      $TTL    60   ; 86400 - 1 day

      @                   IN SOA  dns.faceftw.local. admin.faceftw.local. (
                            1337   ; Serial
                            3600   ; Refresh
                            300    ; Retry
                            3600   ; Expire
                            300)   ; Negative Cache TT

      @                   IN NS   dns.faceftw.local.

      router                 IN A      192.168.0.1

      durandal               IN A      192.168.0.7
      pihole                 IN A      192.168.0.7
      dns                    IN A      192.168.0.7

      port-authority         IN A      192.168.0.26

      fabricator             IN A      192.168.0.42

      archiver               IN A      192.168.0.172
      immich                 IN A      192.168.0.172
      linkwarden             IN A      192.168.0.172
      backrest               IN A      192.168.0.172
      syncthing.archiver     IN A      192.168.0.172
      garage                 IN A      192.168.0.172
      s3.garage              IN A      192.168.0.172
      *.s3.garage            IN CNAME  s3.garage.faceftw.local.
      web.garage             IN A      192.168.0.172
      *.web.garage           IN CNAME  web.garage.faceftw.local.
      jellyfin               IN A      192.168.0.172
      navidrome              IN A      192.168.0.172
    '';
  };

}
