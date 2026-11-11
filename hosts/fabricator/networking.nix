{
  config,
  pkgs,
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
    extraConfig = "country=US";
  };

  networking.useDHCP = false;

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

  systemd.services.disable-wifi-powersave = {
    description = "Disable Wi-Fi power saving";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iw}/bin/iw dev wlan0 set power_save off";
    };
  };

}
