{ ... }:
{
  networking.hostName = "nemesis";
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [
    5353 # mDNS
  ];
}
