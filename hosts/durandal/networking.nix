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
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = false;
  };

  #
  # Networking
  #
  # Essential infrastructure
  # - List your most essential network resources here
  networking = {
    hosts = {
      "192.168.0.1" = [
        "router.faceftw.me"
        "router"
      ];
      "192.168.0.7" = [
        "durandal.faceftw.me"
        "durandal"
      ];
      "192.168.0.72" = [
        "archiver.faceftw.me"
        "archiver"
      ];
    };
  };

  #
  # Services
  #
  # I'm not actually using the dnsmasq service. Pi-hole provides
  # it's own dnsmasq. I'm using Nix' ability to manage the
  # dnsmasq-style configuration file that Pi-hole utilizes.
  # dnsmasq = {
  #   enable = false;
  #   settings = {
  #     address = [ ];
  #     dhcp-name-match = [
  #       "set:hostname-ignore,wpad"
  #       "set:hostname-ignore,localhost"
  #     ];
  #     # Set DHCP option 6 to the DNS server you nodes should use.
  #     dhcp-option = [
  #       "vendor:MSFT,2,1i"
  #       "6,192.168.0.7"
  #     ];
  #     domain = [
  #       "faceftw.me,192.168.0.0/24,local"
  #     ];
  #   };
  # };

  services.pihole-ftl = {
    enable = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "Steven Black's HOSTS";
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

        interface = "10-end0";

        hosts = [
          "192.168.0.1    router"
          "192.168.0.7    durandal"
          "192.168.0.172  archiver"
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
      webserver.api.pwhash = "$BALLOON-SHA256...";
      webserver.api.session.timeout = 43200; # 12h

    };
    # useDnsmasqConfig = true;
  };

  services.pihole-web = {
    enable = true;
    ports = [ 80 ];
  };

  systemd.tmpfiles.rules = [
    # Type Path Mode User Group Age Argument
    "f /etc/pihole/versions 0644 pihole pihole - -"
  ];
}
