{ pkgs, ... }:
{
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
}
