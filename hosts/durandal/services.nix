{
  ...
}:
{
  imports = [
    ./services/acme.nix
    ./services/dns.nix
    ./services/pihole.nix
  ];

  services.nginx.enable = true;
}
