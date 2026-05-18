{
  pkgs,
  lib,
  ...
}:
{

  # Now we can configure ACME
  # security.acme.acceptTerms = true;
  # security.acme.defaults.email = "alex@faceftw.dev";
  # security.acme.certs."faceftw.me" = {
  #   domain = "*.faceftw.me";
  #   dnsProvider = "rfc2136";
  #   environmentFile = "/var/lib/secrets/certs.secret";
  #   # We don't need to wait for propagation since this is a local DNS server
  #   dnsPropagationCheck = false;

  #   # preliminarySelfsigned = true;
  #   # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
  # };

  systemd.services.dns-rfc2136-conf = {
    requiredBy = [
      "acme-faceftw.me.service"
      "bind.service"
    ];
    before = [
      "acme-faceftw.me.service"
      "bind.service"
    ];
    unitConfig = {
      ConditionPathExists = "!/var/lib/secrets/dnskeys.conf";
    };
    serviceConfig = {
      Type = "oneshot";
      UMask = 77;
    };
    path = [ pkgs.bind ];
    script = ''
      mkdir -p /var/lib/secrets
      chmod 755 /var/lib/secrets
      tsig-keygen rfc2136key.faceftw.me > /var/lib/secrets/dnskeys.conf
      chown named:root /var/lib/secrets/dnskeys.conf
      chmod 400 /var/lib/secrets/dnskeys.conf

      # extract secret value from the dnskeys.conf
      while read x y; do if [ "$x" = "secret" ]; then secret="''${y:1:''${#y}-3}"; fi; done < /var/lib/secrets/dnskeys.conf

      cat > /var/lib/secrets/certs.secret << EOF
      RFC2136_NAMESERVER='127.0.0.1:53'
      RFC2136_TSIG_ALGORITHM='hmac-sha256.'
      RFC2136_TSIG_KEY='rfc2136key.faceftw.me'
      RFC2136_TSIG_SECRET='$secret'
      EOF
      chmod 400 /var/lib/secrets/certs.secret
    '';
  };
}
