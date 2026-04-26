{
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
        domain.name = "faceftw.me";
        domain.local = true;

        domainNeeded = true;
        expandHosts = true;

        interface = "end0";

        hosts = [
          "192.168.0.1    router"
          "192.168.0.7    durandal"
          "192.168.0.172  archiver"
        ];

        hostRecord = [
          "durandal.faceftw.me, 192.168.0.7"
          "*.archiver.faceftw.me, 192.168.0.172"
          "router.faceftw.me, 192.168.0.1"
        ];

        upstreams = [
          "1.1.1.1"
          "1.1.1.2"
          "localhost#5335"
        ];

        revServers = [
          "true,192.168.0.0/24,192.168.0.1,faceftw.me"
        ];
      };

      ntp.ipv4.active = false;
      ntp.ipv6.active = false;
      ntp.sync.active = false;

      # To manage the web login:
      # 1) Temporarily set misc.readOnly to false in
      #    configuration.nix and switch to it.
      # 2) Manually set a password:
      #    Pi-hole web console > Settings > All settings >
      #    Webserver and API > webserver.api.password > Value: ******
      # 3) Read the generated hash:
      #    sudo pihole-FTL --config webserver.api.pwhash
      webserver.api.pwhash = "";
      webserver.api.session.timeout = 43200; # 12h
      misc.readOnly = false;

    };
    # useDnsmasqConfig = true;
  };

  services.pihole-web = {
    enable = true;
    ports = [ 80 ];
  };
  defaultUser.extraGroups = [ "pihole" ];

  systemd.tmpfiles.rules = [
    # Type Path Mode User Group Age Argument
    "f /etc/pihole/versions 0644 pihole pihole - -"
  ];

}
