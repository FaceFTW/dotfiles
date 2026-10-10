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

  # No reverse proxy since this operates on the specific ports
  services.rustdesk-server.enable = true;
  services.rustdesk-server.openFirewall = true;
  services.rustdesk-server.signal.relayHosts = [ "localhost" ];
}
