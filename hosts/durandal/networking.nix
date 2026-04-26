{
  ...
}:
{
  networking.hostName = "durandal";
  networking.firewall.allowedTCPPorts = [
    80
  ];
  networking.firewall.allowPing = true;

  networking.useDHCP = false;
  services.resolved.enable = true;
  services.resolved.settings.Resolve.LLMNR = false;
  services.resolved.settings.Resolve.DNSStubListener = false;
  services.resolved.settings.Resolve.MulticastDNS = false;

  # NOTE: Local router gives staticIP
  systemd.network.enable = true;
  systemd.network.networks."10-end0" = {
    matchConfig.Name = "end0";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = true;
  };
  systemd.services.systemd-udevd.restartIfChanged = false;

  #
  # Networking
  #
  # Essential infrastructure
  # - List your most essential network resources here
  networking = {
    hosts = {
      "192.168.0.1" = [
        "router.faceftw.me"
        "router"
      ];
      "192.168.0.7" = [
        "durandal.faceftw.me"
        "durandal"
      ];
      "192.168.0.72" = [
        "archiver.faceftw.me"
        "archiver"
      ];
    };
  };

}
