#!/bin/bash
i2c_dev=$(${final.i2c-tools}/bin/i2cdetect -l | grep "SMBus I801 adapter" | grep -Po "i2c-\d+")
if [ $? = 0 ]; then
	echo "Found I2C device /dev/${i2c_dev}"
	dev_path=/sys/bus/i2c/devices/$i2c_dev/${i2c_dev/i2c-/}-003a
	if [ ! -d "$dev_path" ]; then
		echo "led-ugreen 0x3a" > /sys/bus/i2c/devices/"${i2c_dev}"/new_device
	elif [ "$(cat "$dev_path"/name)" != "led-ugreen" ]; then
		echo "ERROR: the device ${i2c_dev/i2c-/}-003a has been registered as $(cat "$dev_path"/name)"
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

exit-trap() {
if [[ -f "/var/run/ugreen-diskiomon.lock" ]]; then
	rm "/var/run/ugreen-diskiomon.lock"
fi
kill $smart_check_pid 2>/dev/null
kill $disk_online_check_pid 2>/dev/null
}
trap 'exit-trap' EXIT

if [[ -f "/var/run/ugreen-diskiomon.lock" ]]; then
echo "ugreen-diskiomon already running!"
exit 1
fi
touch /var/run/ugreen-diskiomon.lock


# led-disk mapping (see https://github.com/miskcoo/ugreen_dx4600_leds_controller/pull/4)
MAPPING_METHOD=hctl # ata, hctl, serial
led_map=(disk1 disk2)

# hctl, $> lsblk -S -x hctl -o hctl,serial,name
# NOTE: It is reported that the order below should be adjusted for each model.
# Please check the disk mapping section in https://github.com/miskcoo/ugreen_dx4600_leds_controller/blob/master/README.md.
hctl_map=("0:0:0:0" "1:0:0:0")
# ata number, $> ls /sys/block | egrep ata\d
# ata_map=("ata1" "ata2")

# polling rate for smartctl. 360 seconds by default
CHECK_SMART_INTERVAL=360
# refresh interval from disk leds
LED_REFRESH_INTERVAL=0.1

# polling rate for checking disk online. 5 seconds by default
CHECK_DISK_ONLINE_INTERVAL=5

COLOR_DISK_HEALTH='0 255 0'
COLOR_DISK_UNAVAIL='255 0 0'
COLOR_SMART_FAIL='255 0 0'
BRIGHTNESS_DISK_LEDS=255

function disk_enumerating_string() {
	${final.util-linux}/bin/lsblk -S -o name,${MAPPING_METHOD},tran | grep sata
}

echo Enumerating disks based on $MAPPING_METHOD...
declare -A dev_map
while read -r line
do
	# shellcheck disable=SC2206
	blk_line=($line)
	key=${blk_line[1]}
	val=${blk_line[0]}
	dev_map[${key}]=${val}
	echo $MAPPING_METHOD "${key} >> ${dev_map[${key}]}"
done <<< "$(disk_enumerating_string)"

# initialize LEDs
for i in "${!led_map[@]}"; do
	led=${led_map[i]}
	if [[ -d /sys/class/leds/$led ]]; then
		echo oneshot > /sys/class/leds/"$led"/trigger
		echo 1 > /sys/class/leds/"$led"/invert
		echo 100 > /sys/class/leds/"$led"/delay_on
		echo 100 > /sys/class/leds/"$led"/delay_off
		echo "$COLOR_DISK_HEALTH" > /sys/class/leds/"$led"/color
		echo "$BRIGHTNESS_DISK_LEDS" > /sys/class/leds/"$led"/brightness

		# find corresponding device

		if [[ -v "dev_map[${hctl_map[i]}]" ]]; then
			dev=${dev_map[${hctl_map[i]}]}

			if [[ -f /sys/class/block/${dev}/stat ]]; then
				devices[led]=${dev}
			else
				# turn off the led if no disk installed on this slot
				echo 0 > /sys/class/leds/"${led_map[$led]}"/brightness
				echo none > /sys/class/leds/"${led_map[$led]}"/trigger
			fi
		else
			# turn off the led if no disk installed on this slot
			echo 0 > /sys/class/leds/"${led_map[$led]}"/brightness
			echo none > /sys/class/leds/"${led_map[$led]}"/trigger
		fi
	fi
done

# disk health check
(
	while true; do
		for led in "${!devices[@]}"; do
			if ! [[ $(cat /sys/class/leds/"${led_map[$led]}"/color) == "$COLOR_DISK_HEALTH" ]]; then
				continue;
			fi

			dev=${devices[$led]}

			# read the smart status return code, but ignore if the drive is on standby
			/usr/sbin/smartctl -H "/dev/$dev" -n standby,0 &> /dev/null
			RET=$?

			# check return code for critical errors (any bit set except bit 5)
			# possible return bits set: https://invent.kde.org/system/kpmcore/-/merge_requests/28
			if (( "$RET" & ~32 )); then
				echo "$COLOR_SMART_FAIL" > /sys/class/leds/"${led_map[$led]}"/color
				echo "Disk failure detected on /dev/$dev at $(date '+%Y-%m-%d %H:%M:%S')"
				continue
			fi
		done
		sleep ${CHECK_SMART_INTERVAL}s
	done
) &
smart_check_pid=$!

# check disk online status
(
	while true; do
		for led in "${!devices[@]}"; do
			dev=${devices[$led]}
			if ! [[ $(cat /sys/class/leds/"${led_map[$led]}"/color) == "$COLOR_DISK_HEALTH" ]]; then
				continue;
			fi

			if [[ ! -f /sys/class/block/${dev}/stat ]]; then
				echo "$COLOR_DISK_UNAVAIL" > /sys/class/leds/"${led_map[$led]}"/color 2>/dev/null
				echo "Disk /dev/$dev went offline at $(date '+%Y-%m-%d %H:%M:%S')"
				continue
			fi
		done
		sleep ${CHECK_DISK_ONLINE_INTERVAL}s
	done
) &
disk_online_check_pid=$!

declare -A diskio_data_rw
while true; do
	for led in "${!devices[@]}"; do
		# if $dev does not exist, diskio_new_rw="", which will be safe
		diskio_new_rw="$(cat /sys/block/"${devices[$led]}"/stat 2>/dev/null)"
		if [ "${diskio_data_rw[$led]}" != "${diskio_new_rw}" ]; then
			echo 1 > /sys/class/leds/"${led_map[$led]}"/shot
		fi
		diskio_data_rw[$led]=$diskio_new_rw
	done
	sleep ${LED_REFRESH_INTERVAL}s
done