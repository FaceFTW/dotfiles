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
  networking.firewall.allowPing = true;

  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    secretsFile = config.sops.secrets.wifi_secrets.path;
    networks."Orbi89".pskRaw = "ext:home-psk";
  };

  networking.useDHCP = false;

  services.resolved.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-end0" = {
    matchConfig.Name = "end0";
    linkConfig.RequiredForOnline = false;
  };

  # NOTE Local router gives Static IP
  systemd.network.networks."10-wlan0" = {
    matchConfig.Name = "wlan0";
    networkConfig.DHCP = "ipv4";
    linkConfig.RequiredForOnline = "routable";
  };

}
