import { BarShadowWindow, BarWindow } from "./src/windows/bar";
import app from "ags/gtk4/app";
import { config, theme } from "./options";
import { createBinding, For, onCleanup, This } from "ags";
import { Gtk } from "ags/gtk4";
import { qs_page_set } from "./src/modules/quicksettings/quicksettings";
import { QuickSettingsWindow } from "./src/windows/quicksettings";
import { CalendarWindow } from "./src/windows/calendar";
import { PowerMenuWindow, VerificationWindow } from "./src/windows/powermenu";
import { OsdWindow } from "./src/windows/osd";
import { NotificationsListWindow } from "./src/windows/notificationslist";
import { NotificationsWindow } from "./src/windows/notifications";
import { VolumeWindow } from "./src/windows/volume";
import { NetworkWindow } from "./src/windows/network";
import { BluetoothWindow } from "./src/windows/bluetooth";
import { PowerWindow } from "./src/windows/power";
import { dependencies, hasBarItem } from "./src/lib/utils";

export const windows_names = {
	bar: "bar",
	bar_shadow: "barshadow",
	notifications_popup: "notificationspopup",
	quicksettings: "quicksettings",
	osd: "osd",
	powermenu: "powermenu",
	verification: "verification",
	calendar: "calendar",
	notificationslist: "notificationslist",
	volume: "volume",
	network: "network",
	bluetooth: "bluetooth",
	power: "power",
	clipboard: "clipboard",
};

export function hideWindows() {
	const ignore = [
		windows_names.bar,
		windows_names.bar_shadow,
		windows_names.osd,
	];

	app.get_windows()
		.filter((window) => !ignore.includes(window.name))
		.forEach((w) => {
			app.get_window(w.name)?.hide();
		});
	qs_page_set("main");
}

export function windows() {
	// prettier-ignore
	const windows: Array<[condition: boolean, open: () => void]> = [
    [true, QuickSettingsWindow],
    [true, CalendarWindow],          // <------ always open
    [true, PowerMenuWindow],         //  ↓↓↓↓ open if condition === true
    [true, VerificationWindow],
    [config.notifications.enabled && hasBarItem("notificationslist"),    NotificationsListWindow],
    [config.notifications.enabled,                                       NotificationsWindow],
    [config.osd.enabled,                                                 OsdWindow],
    [hasBarItem("volume") || hasBarItem("microphone"),                   VolumeWindow],
    [hasBarItem("network"),                                              NetworkWindow],
    [hasBarItem("bluetooth"),                                            BluetoothWindow],
    [hasBarItem("battery"),                                              PowerWindow],
  ];

	for (const [condition, open] of windows) {
		if (condition) open();
	}

	const monitors = createBinding(app, "monitors");

	<For each={monitors}>
		{(monitor) => (
			<This this={app}>
				<BarWindow
					gdkmonitor={monitor}
					$={(self) => onCleanup(() => self.destroy())}
				/>
				{theme.shadow && (
					<BarShadowWindow
						gdkmonitor={monitor}
						$={(self) => onCleanup(() => self.destroy())}
					/>
				)}
			</This>
		)}
	</For>;
}
