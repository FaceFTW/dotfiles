{
  ...
}:
{
  networking.hostName = "port-authority";
  networking.firewall.allowedTCPPorts = [
    22
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
    networkConfig.MulticastDNS = "no";
    # linkConfig.RequiredForOnline = true;
  };
  systemd.services.systemd-udevd.restartIfChanged = false;

}
