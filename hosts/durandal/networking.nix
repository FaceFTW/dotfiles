{
  config,
  lib,
  pkgs,
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
    linkConfig.RequiredForOnline = true;
  };
  systemd.services.systemd-udevd.restartIfChanged = false;

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

  # systemd.services.pihole-ftl-setup =
  #   let
  #     pihole = config.services.pihole-ftl.piholePackage;
  #     makePayload = list: {
  #       inherit (list) type enabled;
  #       address = list.url;
  #       comment = list.description;
  #     };
  #     payloads = map makePayload config.services.pihole-ftl.lists;
  #     expectedListsJSON = builtins.toJSON payloads;
  #     macvendorURL = lib.strings.escapeShellArg config.services.pihole-ftl.macvendorURL;
  #   in
  #   {
  #     # add sysinit-reactivation.target, so that service is automatically started on nixos-rebuild switch
  #     requiredBy = [ "sysinit-reactivation.target" ];
  #     before = [ "sysinit-reactivation.target" ];
  #     environment = {
  #       EXPECTED_LISTS = expectedListsJSON;
  #     };
  #     script = lib.mkForce ''
  #       # Can't use -u (unset) because api.sh uses API_URL before it is set
  #       set -eo pipefail
  #       pihole="${lib.getExe pihole}"
  #       jq="${lib.getExe pkgs.jq}"

  #       ${lib.getExe pkgs.curl} --retry 3 --retry-delay 5 "${macvendorURL}" -o "${config.services.pihole-ftl.settings.files.macvendor}" || echo "Failed to download MAC database from ${macvendorURL}"

  #       # If the database doesn't exist, it needs to be created with gravity.sh
  #       if [ ! -f '${config.services.pihole-ftl.settings.files.gravity}' ]; then
  #         $pihole -g
  #         # Send SIGRTMIN to FTL, which makes it reload the database, opening the newly created one
  #         ${lib.getExe' pkgs.procps "kill"} -s SIGRTMIN $(systemctl show --property MainPID --value ${config.systemd.services.pihole-ftl.name})
  #       fi

  #       source ${pihole}/share/pihole/advanced/Scripts/api.sh
  #       source ${pihole}/share/pihole/advanced/Scripts/utils.sh

  #       any_failed=0
  #       any_changed=0

  #       addList() {
  #         local payload="$1"

  #         echo "Adding list: $payload"
  #         local result=$(PostFTLData "lists" "$payload")

  #         local error="$($jq '.error' <<< "$result")"
  #         if [[ "$error" != "null" ]]; then
  #             echo "Error: $error"
  #             any_failed=1
  #             return
  #         fi

  #         id="$($jq '.lists.[].id?' <<< "$result")"
  #         if [[ "$id" == "null" ]]; then
  #             any_failed=1
  #             error="$($jq '.processed.errors.[].error' <<< "$result")"
  #             echo "Error: $error"
  #             return
  #         fi

  #         echo "Added list ID $id: $result"
  #         any_changed=1
  #       }

  #       removeListsBatch() {
  #         local payload="$1"

  #         echo "Removing lists: $payload"
  #         local result=$(PostFTLData "lists:batchDelete" "$payload")

  #         local error="$($jq '.error' <<< "$result")"
  #         if [[ "$error" != "" ]]; then
  #             echo "Error: $error"
  #             any_failed=1
  #             return
  #         fi

  #         echo "Removed lists"
  #         any_changed=1
  #       }

  #       for i in 1 2 3; do
  #         (TestAPIAvailability) && break
  #         echo "Retrying API shortly..."
  #         ${lib.getExe' pkgs.coreutils "sleep"} .5s
  #       done;

  #       LoginAPI

  #       # get lists currently on pihole
  #       actualListsResponse=$(GetFTLData "lists")
  #       actualLists=$($jq -r '.lists | pick(.[] | .type,.enabled,.address,.comment)' <<< "$actualListsResponse")

  #       # get lists on pihole but not in $EXPECTED_LISTS
  #       listsToRemove=$($jq -c -n --argjson expected "$EXPECTED_LISTS" --argjson actual "$actualLists" '{"expected": $expected,"actual":$actual} | .actual-.expected | [.[] | .["item"] = .address] | pick(.[] | .type,.item)')
  #       if [[ $listsToRemove != "null" ]]; then
  #         removeListsBatch "$listsToRemove"
  #       fi

  #       # iterate lists in $EXPECTED_LISTS but not on pihole
  #       readarray -t listsToAdd < <($jq -c -n --argjson expected "$EXPECTED_LISTS" --argjson actual "$actualLists" '{"expected": $expected,"actual":$actual} | .expected-.actual | .[]')
  #       for i in "''${listsToAdd[@]}"; do
  #         addList "$i"
  #       done

  #       # Run gravity.sh to load any new lists
  #       if [[ $any_changed -eq 1 ]]; then
  #         $pihole -g
  #       fi
  #       exit $any_failed
  #     '';
  #   };

  defaultUser.extraGroups = [ "pihole" ];

  systemd.tmpfiles.rules = [
    # Type Path Mode User Group Age Argument
    "f /etc/pihole/versions 0644 pihole pihole - -"
  ];
}
