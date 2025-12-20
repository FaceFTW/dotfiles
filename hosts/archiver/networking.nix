{ ... }:
{
  networking.hostName = "archiver";
  networking.firewall.allowedTCPPorts = [
    22
  ];
  networking.useDHCP = false;

  services.resolved.enable = true;
  services.resolved.extraConfig = ''
    MulticastDNS=yes
  '';
  services.resolved.llmnr = "resolve";

  # NOTE: Configured such that the local router gives this a static IP
  # on the local network
  systemd.network.enable = true;
  systemd.network.networks."10-enp2s0" = {
    matchConfig.Name = "enp2s0";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = true;
  };

}
