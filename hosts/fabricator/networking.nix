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
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlan0" ];
  networking.wireless.secretsFile = config.sops.secrets.wifi_secrets.path;
  networking.wireless.networks."Orbi89".pskRaw = "ext:home-psk";
  networking.useDHCP = false;

  services.resolved.enable = true;
  services.resolved.extraConfig = ''
    MulticastDNS=yes
  '';
  services.resolved.llmnr = "resolve";

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
