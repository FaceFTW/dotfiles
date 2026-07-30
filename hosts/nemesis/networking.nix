{ ... }:
{
  networking.hostName = "nemesis";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.0.7#dns.faceftw.local" ];

  services.resolved.enable = true;
  services.resolved.settings.Resolve.DNS = [
    "192.168.0.7"
  ];
  services.resolved.settings.Resolve.Domains = [ "~." ];
  services.resolved.settings.Resolve.FallbackDNS = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
}
