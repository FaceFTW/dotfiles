import { createBinding, createComputed } from "ags";
import AstalBattery from "gi://AstalBattery?version=0.1";
import AstalNetwork from "gi://AstalNetwork";
import AstalWp from "gi://AstalWp?version=0.1";

export const icons = {
	search: "search-symbolic",
	settings: "settings-2-symbolic",
	clipboard: "clipboard-symbolic",
	keyboard: "keyboard-symbolic",
	memory: "memory-stick-symbolic",
	cpu: "cpu-symbolic",
	arrow: {
		left: "chevron-left-symbolic",
		right: "chevron-right-symbolic",
		down: "chevron-down-symbolic",
		up: "chevron-up-symbolic",
	},
	trash: "trash-2-symbolic",
	player: {
		icon: "music-symbolic",
		play: "play-symbolic",
		pause: "pause-symbolic",
		prev: "skip-back-symbolic",
		next: "skip-forward-symbolic",
	},
	refresh: "refresh-cw-symbolic",
	check: "check-symbolic",
	powerprofiles: {
		"power-saver": "speedometer-1-symbolic",
		balanced: "speedometer-2-symbolic",
		performance: "speedometer-3-symbolic",
	} as Record<string, any>,
	network: {
		wifi: {
			disabled: "wifi-off-symbolic",
			1: "wifi-1-symbolic",
			2: "wifi-2-symbolic",
			3: "wifi-3-symbolic",
			4: "wifi-4-symbolic",
		},
		wired: "ethernet-port-symbolic",
	},
	bluetooth: "bluetooth-symbolic",
	bell: "bell-symbolic",
	bell_off: "bell-off-symbolic",
	microphone: {
		default: "mic-symbolic",
		muted: "mic-off-symbolic",
	},
	powermenu: {
		sleep: "moon-symbolic",
		reboot: "refresh-cw-symbolic",
		logout: "log-out-symbolic",
		shutdown: "power-symbolic",
	} as Record<string, any>,
	volume: {
		muted: "volume-x-symbolic",
		low: "volume-symbolic",
		medium: "volume-1-symbolic",
		high: "volume-2-symbolic",
	},
	battery: {
		charging: "battery-charging-symbolic",
		1: "battery-1-symbolic",
		2: "battery-2-symbolic",
		3: "battery-3-symbolic",
		4: "battery-4-symbolic",
	},
	brightness: "sun-symbolic",
	video: "video-symbolic",
	close: "x-symbolic",
	apps_default: "application-x-executable",
	droplet: "droplet-symbolic",
	clock: "clock-symbolic",
	calendar: "calendar-symbolic",
	location: "map-pin-symbolic",
	weather: {
		clear: {
			day: "sun-symbolic",
			night: "moon-symbolic",
		},
		cloudy: {
			day: "cloud-sun-symbolic",
			night: "cloud-moon-symbolic",
		},
		fog: "cloud-fog-symbolic",
		rain: {
			day: "cloud-sun-rain-symbolic",
			night: "cloud-moon-rain-symbolic",
			general: "cloud-drizzle-symbolic",
		},
		snow: "cloud-snow-symbolic",
		shower_rain: "cloud-rain-symbolic",
		thunder: "cloud-lightning-symbolic",
	},
};

export function getVolumeIcon(speaker?: AstalWp.Endpoint) {
	let volume = speaker?.volume;
	let muted = speaker?.mute;
	let speakerIcon = speaker?.icon;
	if (volume == null || speakerIcon == null) return "";

	if (volume === 0 || muted) {
		return icons.volume.muted;
	} else if (volume < 0.33) {
		return icons.volume.low;
	} else if (volume < 0.66) {
		return icons.volume.medium;
	} else {
		return icons.volume.high;
	}
}

const wp = AstalWp.get_default();
const speaker = wp?.audio.defaultSpeaker!;
const speakerVar = createComputed([
	createBinding(speaker, "description"),
	createBinding(speaker, "volume"),
	createBinding(speaker, "mute"),
]);
export const VolumeIcon = speakerVar(() => getVolumeIcon(speaker));



export function getNetworkIcon(network: AstalNetwork.Network) {
	const { connectivity, wifi, wired } = network;

	if (network.primary === AstalNetwork.Primary.WIRED) {
		if (wired.internet === AstalNetwork.Internet.CONNECTED) {
			return icons.network.wired;
		}
	}

	if (network.primary === AstalNetwork.Primary.WIFI) {
		const { strength, internet, enabled } = wifi;

		if (!enabled || connectivity === AstalNetwork.Connectivity.NONE) {
			return icons.network.wifi[1];
		}

		if (strength < 26) {
			if (internet === AstalNetwork.Internet.DISCONNECTED) {
				return icons.network.wifi[4];
			} else if (internet === AstalNetwork.Internet.CONNECTED) {
				return icons.network.wifi[4];
			} else if (internet === AstalNetwork.Internet.CONNECTING) {
				return icons.network.wifi[4];
			}
		} else if (strength < 51) {
			if (internet === AstalNetwork.Internet.DISCONNECTED) {
				return icons.network.wifi[3];
			} else if (internet === AstalNetwork.Internet.CONNECTED) {
				return icons.network.wifi[3];
			} else if (internet === AstalNetwork.Internet.CONNECTING) {
				return icons.network.wifi[3];
			}
		} else if (strength < 76) {
			if (internet === AstalNetwork.Internet.DISCONNECTED) {
				return icons.network.wifi[2];
			} else if (internet === AstalNetwork.Internet.CONNECTED) {
				return icons.network.wifi[2];
			} else if (internet === AstalNetwork.Internet.CONNECTING) {
				return icons.network.wifi[2];
			}
		} else {
			if (internet === AstalNetwork.Internet.DISCONNECTED) {
				return icons.network.wifi[1];
			} else if (internet === AstalNetwork.Internet.CONNECTED) {
				return icons.network.wifi[1];
			} else if (internet === AstalNetwork.Internet.CONNECTING) {
				return icons.network.wifi[1];
			}
		}

		return icons.network.wifi[1];
	}

	return icons.network.wifi[1];
}

export function getNetworkIconBinding() {
	const network = AstalNetwork.get_default();

	return createComputed([
		createBinding(network, "connectivity"),
		...(network.wifi !== null
			? [createBinding(network.wifi, "strength")]
			: []),
		createBinding(network, "primary"),
	])(() => getNetworkIcon(network));
}

export function getAccessPointIcon(accessPoint: AstalNetwork.AccessPoint) {
	const strength = accessPoint.strength;

	if (strength <= 25) {
		return icons.network.wifi[4];
	} else if (strength <= 50) {
		return icons.network.wifi[3];
	} else if (strength <= 75) {
		return icons.network.wifi[2];
	} else {
		return icons.network.wifi[1];
	}
}
