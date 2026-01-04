{ ... }:
{
  networking.hostName = "archiver";
  networking.firewall.allowedTCPPorts = [
    22
    80
    111
  ];
  networking.firewall.allowPing = true;

  services.resolved.enable = true;
  services.resolved.extraConfig = ''
    MulticastDNS=yes
  '';
  services.resolved.llmnr = "resolve";

  # NOTE: Configured such that the local router gives this a static IP
  # on the local network
  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-enp2s0" = {
    matchConfig.Name = "enp2s0";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    networkConfig.MulticastDNS = "yes";
    linkConfig.RequiredForOnline = true;
    linkConfig.MTUBytes = 1500;

  };

  # NOTE: This assumes this is only in the local network and not exposed to the outside
  #       so no security here. I might do it later when I feel like it
  services.samba.enable = true;
  services.samba.openFirewall = true;
  services.samba-wsdd.enable = true;
  services.samba-wsdd.openFirewall = true;
  services.samba.settings.global."log level" = "3";
  services.samba.settings.global."syslog" = "3";
  services.samba.settings.global."workgroup" = "WORKGROUP";
  services.samba.settings.global."server string" = "archiver";
  services.samba.settings.global."netbios name" = "archiver";
  services.samba.settings.global."passdb backend" = "smbpasswd";
  services.samba.settings.global."smb passwd file" = "/etc/samba/smbpasswd";
  services.samba.settings.global."server role" = "standalone server";
  # services.samba.settings.global."server min protocol" = "SMB3_11";
  services.samba.settings.global."server smb encrypt" = "required";
  services.samba.settings.global."server signing" = "mandatory";
  services.samba.settings.global."winbind nss info" = "rfc2307";
  services.samba.settings.global."security" = "user";
  services.samba.settings.global."hosts allow" = "192.168.0. 127.0.0.1 localhost";
  services.samba.settings.global."hosts deny" = "0.0.0.0/0";
  services.samba.settings.global."map to guest" = "bad user";
  services.samba.settings.global."deadtime" = "5";
  services.samba.settings.global."acl allow execute always" = "yes";

  # Disable samba printing because of course that is a thing
  services.samba.settings.global."printing" = "bsd";
  services.samba.settings.global."printcap name" = "/dev/null";
  services.samba.settings.global."load printers" = "no";
  services.samba.settings.global."disable spoolss" = "yes";

  services.samba.settings.motorway."path" = "/export/motorway";
  services.samba.settings.motorway."browseable" = "yes";
  services.samba.settings.motorway."writable" = "yes";
  services.samba.settings.motorway."create mask" = "0777";
  services.samba.settings.motorway."directory mask" = "0755";
  services.samba.settings.motorway."force user" = "face";
  services.samba.settings.motorway."force group" = "users";

  services.samba.settings.archive."path" = "/export/archive";
  services.samba.settings.archive."browseable" = "yes";
  services.samba.settings.archive."writable" = "yes";
  services.samba.settings.archive."create mask" = "0777";
  services.samba.settings.archive."directory mask" = "0755";
  services.samba.settings.archive."force user" = "face";
  services.samba.settings.archive."force group" = "users";
}
