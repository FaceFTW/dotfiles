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
        name = "faceftw.me";
        file = "/etc/bind/zones/faceftw.me.zone";
        master = true;
        extraConfig = "allow-update { key rfc2136key.faceftw.me.; };";
      }
    ];
  };

  environment.etc."bind/zones/faceftw.me.zone" = {
    enable = true;
    user = "named";
    group = "named";
    mode = "0644";
    text = ''
      $ORIGIN faceftw.me.
      $TTL 86400      ; 1 day

      @                       IN SOA    dns root(
                                                1337   ; Serial
                                                3600   ; Refresh
                                                300    ; Retry
                                                3600   ; Expire
                                                300)   ; Negative Cache TT
                              IN NS     dns


      dns                     IN A      192.168.0.172

      archiver                IN A      192.168.0.172
      immich                  IN A      192.168.0.172
      linkwarden              IN A      192.168.0.172
      backrest                IN A      192.168.0.172
      syncthing.archiver      IN A      192.168.0.172
      garage                  IN A      192.168.0.172
      jellyfin                IN A      192.168.0.172

      durandal                IN A      192.168.0.7
      pihole                  IN A      192.168.0.7
    '';
  };

}
