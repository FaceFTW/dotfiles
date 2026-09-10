{
  config,
  pkgs,
  ...
}:
{
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "alex@faceftw.dev";
  security.acme.certs."faceftw.dev" = {
    domain = "*.faceftw.dev";
    dnsProvider = "cloudflare";
    environmentFile = "/run/secrets/cloudflare_acme";
    # server = "https://acme-staging-v02.api.letsencrypt.org/directory";

    postRun = ''
      # set permission on dir
      ${pkgs.acl}/bin/setfacl -m u:nginx:rx \
      /var/lib/acme/faceftw.dev

      # set permission on key file
      ${pkgs.acl}/bin/setfacl -m u:nginx:r \
      /var/lib/acme/faceftw.dev/*.pem
    '';

    reloadServices = [ "nginx" ];
    group = config.services.nginx.group;
  };
}
