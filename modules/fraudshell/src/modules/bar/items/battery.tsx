//@ts-expect-error 2307
import AstalBattery from "gi://AstalBattery";
import BarItem from "@/src/widgets/baritem";
import { createBinding, createComputed } from "gnim";
import { windows_names } from "@/windows";
import { isVertical } from "../bar";
import { config, theme } from "@/options";

export function Battery() {
	const conf = config.bar.modules.battery;
	const battery = AstalBattery.get_default();
	const percentage = createBinding(battery, "percentage");

	console.log(battery.state);

	const getBatteryIcon = (battery: AstalBattery.Device) => {
		const percent = (Math.round(battery.percentage * 10) * 10)
			.toFixed()
			.padStart(3, "0");
		const charging =
			battery.state === AstalBattery.State.CHARGING ||
			battery.state === AstalBattery.State.FULLY_CHARGED
				? "-charging"
				: "";

		return battery.state === AstalBattery.State.FULLY_CHARGED
			? "battery-full-charging"
			: `battery-${percent}${charging}`;
	};

	const batteryVar = createComputed([
		createBinding(battery, "percentage"),
		createBinding(battery, "state"),
	]);
	const BatteryIcon = batteryVar(() => getBatteryIcon(battery));

	return (
		<BarItem
			window={windows_names.power}
			onPrimaryClick={conf["on-click"]}
			onSecondaryClick={conf["on-click-right"]}
			onMiddleClick={conf["on-click-middle"]}
			visible={createBinding(battery, "isPresent")}
			data={{
				icon: (
					<image
						hexpand={isVertical}
						pixelSize={theme["icon-size"].normal}
						iconName={BatteryIcon}
					/>
				),
				percent: (
					<label
						label={percentage((v) =>
							Math.floor(v * 100).toString(),
						)}
						hexpand={isVertical}
					/>
				),
			}}
			format={conf.format}
		/>
	);
}
