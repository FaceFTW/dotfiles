{ pkgs, ... }:
{
  users.users.watchman = {
    isSystemUser = true;
    group = "watchman";
    createHome = false;
  };
  users.groups.watchman = { };

  systemd.services.ugreen-led-cfg = {
    wantedBy = [ "sysinit.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      #!${pkgs.bash}/bin/bash
      set -e

      i2c_dev=$(${pkgs.i2c-tools}/bin/i2cdetect -l | grep "SMBus I801 adapter" | grep -Po "i2c-\d+")
      if [ $? = 0 ]; then
              echo "Found I2C device /dev/''${i2c_dev}"
              dev_path=/sys/bus/i2c/devices/$i2c_dev/''${i2c_dev/i2c-/}-003a
              if [ ! -d $dev_path ]; then
                  echo "led-ugreen 0x3a" > /sys/bus/i2c/devices/''${i2c_dev}/new_device
              elif [ "$(cat $dev_path/name)" != "led-ugreen" ]; then
                  echo "ERROR: the device ''${i2c_dev/i2c-/}-003a has been registered as $(cat $dev_path/name)"
                  exit 1
              fi
      else
              echo "I2C device not found!"
      fi

      # Set link trigger
      echo netdev > /sys/class/leds/netdev/trigger
      echo enp2s0 > /sys/class/leds/netdev/device_name
      echo 1 > /sys/class/leds/netdev/link
      echo 1 > /sys/class/leds/netdev/tx
      echo 1 > /sys/class/leds/netdev/rx
      echo 100 > /sys/class/leds/netdev/interval
    '';

  };

  services.opendkim.enable = true;
  services.opendkim.domains = "csl:faceftw.dev";
  services.opendkim.selector = "alerts._domainkey";
  services.opendkim.user = "watchman";
  services.opendkim.group = "watchman";
  services.opendkim.settings.Mode = "sv";
  services.opendkim.settings.Domain = "faceftw.dev";
  services.opendkim.settings.RequireSafeKeys = "False";
  services.opendkim.settings.ExternalIgnoreList = "127.0.0.1,::1,faceftw.dev";
  services.opendkim.settings.InternalHosts = "127.0.0.1,::1";

  services.postfix.enable = true;
  services.postfix.user = "watchman";
  services.postfix.group = "watchman";
  services.postfix.rootAlias = "archiver-alerts@faceftw.dev";
  services.postfix.settings.main.relayhost = [ "faceftw.dev" ];
  services.postfix.settings.main.smtp_tls_security_level = "dane";
  services.postfix.settings.main.smtpd_milters = "unix:/run/opendkim/opendkim.sock";
  services.postfix.settings.main.non_sntpd_milters = "$smtpd_milters";
  services.postfix.settings.main.milter_default_action = "accept";
  services.postfix.settings.main.smtp_generic_maps = "hash:/var/lib/postfix/generic";
  services.postfix.mapFiles.generic = ./postfix-generic;

  #   environment.etc."postfix/generic".text = ''
  #     root@archiver.local archiver-alerts@faceftw.dev
  #     @archiver.local archiver-alerts@faceftw.dev
  #   '';

}
