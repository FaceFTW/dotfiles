{
  ...
}:
{
  networking.hostName = "durandal";
  networking.firewall.allowedTCPPorts = [
    80
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # mDNS
  ];
  networking.firewall.allowPing = true;

  # NOTE: Local router gives staticIP
  networking.useDHCP = false;

  services.resolved.enable = true;
  services.resolved.settings.Resolve.LLMNR = true;

  # NOTE: Local router gives staticIP
  systemd.network.enable = true;
  systemd.network.networks."10-end0" = {
    matchConfig.Name = "end0";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = false;
  };
}
