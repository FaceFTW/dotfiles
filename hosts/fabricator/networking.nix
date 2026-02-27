{
  config,
  ...
}:
{
  networking.hostName = "fabricator";
  networking.firewall.allowedTCPPorts = [
    22
    80
    5123
    7125
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # mDNS
  ];
  networking.firewall.allowPing = true;

  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    secretsFile = config.sops.secrets.wifi_secrets.path;
    networks."Orbi89".pskRaw = "ext:home-psk";
  };

  networking.useDHCP = false;

  services.resolved.enable = true;
  services.resolved.settings.Resolve.LLMNR = true;

  systemd.network.enable = true;
  systemd.network.networks."10-end0" = {
    matchConfig.Name = "end0";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = false;
  };
  systemd.network.networks."10-wlan0" = {
    matchConfig.Name = "wlan0";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = "routable";
  };

}
