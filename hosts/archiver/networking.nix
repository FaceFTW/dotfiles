{ ... }:
{
  networking.hostName = "archiver";
  networking.firewall.allowedTCPPorts = [
    22 # SSH
    111 # Something Samba Related (Service Discovery?)
    2283 # Immich Direct
    2284 # Immich Proxy
    3014 # Linkwarden Proxy
    3015 # Linkwarden
    8384 # Syncthing GUI
    8385 # Syncthing GUI Proxy
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # mDNS
  ];
  networking.firewall.allowPing = true;

  ############################################
  # systemd networkd+resolved
  ############################################
  services.resolved.enable = true;
  # services.resolved.settings.MulticastDNS = "yes";
  services.resolved.settings.Resolve.LLMNR = true;

  # NOTE: Local router gives static IP
  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-enp2s0" = {
    matchConfig.Name = "enp2s0";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = true;
  };

  ############################################
  # Samba
  ############################################
  # NOTE: Assumes LAN operation only, no exposure to outside
  services.samba.enable = true;
  services.samba.openFirewall = true;
  services.samba-wsdd.enable = true;
  services.samba-wsdd.openFirewall = true;
  services.samba.settings = {
    global."log level" = "3";
    global."syslog" = "3";
    global."workgroup" = "WORKGROUP";
    global."server string" = "archiver";
    global."netbios name" = "archiver";
    global."passdb backend" = "smbpasswd";
    global."smb passwd file" = "/etc/samba/smbpasswd";
    global."server role" = "standalone server";
    # services.samba.settings.global."server min protocol" = "SMB3_11";   # Broken somehow
    global."server smb encrypt" = "required";
    global."server signing" = "mandatory";
    global."winbind nss info" = "rfc2307";
    global."security" = "user";
    global."hosts allow" = "192.168.0. 127.0.0.1 localhost";
    global."hosts deny" = "0.0.0.0/0";
    global."map to guest" = "bad user";
    global."deadtime" = "5";
    global."acl allow execute always" = "yes";

    # Disable samba printing because of course that is a thing
    global."printing" = "bsd";
    global."printcap name" = "/dev/null";
    global."load printers" = "no";
    global."disable spoolss" = "yes";

    # Motorway Share
    motorway."path" = "/export/motorway";
    motorway."browseable" = "yes";
    motorway."writable" = "yes";
    motorway."create mask" = "0777";
    motorway."directory mask" = "0755";
    motorway."force user" = "face";
    motorway."force group" = "users";

    # Archive Share
    archive."path" = "/export/archive";
    archive."browseable" = "yes";
    archive."writable" = "yes";
    archive."create mask" = "0777";
    archive."directory mask" = "0755";
    archive."force user" = "face";
    archive."force group" = "users";
  };
}
