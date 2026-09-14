{
  lib,
  ...
}:
{
  services.pihole-ftl = {
    enable = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "Steven Black's HOSTS";
      }
      {
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
        type = "block";
        enabled = true;
        description = "UBlock Badware Blocklist";
      }
      {
        url = "https://urlhaus.abuse.ch/downloads/hostfile/";
        type = "block";
        enabled = true;
        description = "URLHaus Hostfile Blacklist (Malware)";
      }
      {
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt";
        type = "block";
        enabled = true;
        description = "AdGuard SmartTV Blocklist";
      }
      {
        url = "https://raw.githubusercontent.com/blocklistproject/Lists/master/crypto.txt";
        type = "block";
        enabled = true;
        description = "BlocklistProject Crypto Blocklist";
      }
      {
        url = "https://adaway.org/hosts.txt";
        type = "block";
        enabled = true;
        description = "AdAway Hosts Blocklist";
      }
      {
        url = "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt";
        type = "block";
        enabled = true;
        description = "Frogeye First-Party Trackers (CNAME Cloaking)";
      }
    ];
    openFirewallDNS = true;
    openFirewallWebserver = true;
    queryLogDeleter.enable = true;
    settings = {
      dhcp.active = false; # Handled by Router
      dns = {
        cnameRecords = [ ];

        interface = "end0";

        upstreams = [
          "localhost#1053"
        ];

      };

      ntp.ipv4.active = false;
      ntp.ipv6.active = false;
      ntp.sync.active = false;

      webserver.api.pwhash = "";
      webserver.api.session.timeout = 43200; # 12h
      webserver.tls.cert = lib.mkForce "/var/lib/acme/internal.faceftw.dev/fullchain.pem";
      misc.readOnly = false;

    };
  };

  services.pihole-web = {
    enable = true;
    ports = [ 8080 ];
  };

  systemd.tmpfiles.rules = [
    # Type Path Mode User Group Age Argument
    "f /etc/pihole/versions 0644 pihole pihole - -"
  ];

  modules.nginx.reverse-proxy.pihole = {
    localPort = 8080;
    serverName = "pihole.faceftw.dev";
  };

}
