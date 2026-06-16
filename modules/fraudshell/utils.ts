import { hideWindows, windows_names } from "@/windows";
import { Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { exec, execAsync } from "ags/process";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";
import { qs_page_set } from "../modules/quicksettings/quicksettings";
import { createComputed } from "gnim";
import { config } from "@/options";
import AstalApps from "gi://AstalApps?version=0.1";

interface ScrollInfo {
	dx: number;
	dy: number;
	hovered: boolean;
	shift: boolean;
}

type ScrollHandler = (info: ScrollInfo) => void;

export function attachHoverScroll(box: Gtk.Box, onScroll: ScrollHandler): void {
	let hovered = false;

	const motion = new Gtk.EventControllerMotion();
	motion.connect("enter", () => (hovered = true));
	motion.connect("leave", () => (hovered = false));
	box.add_controller(motion);

	const scrollCtrl = new Gtk.EventControllerScroll({
		flags:
			Gtk.EventControllerScrollFlags.VERTICAL |
			Gtk.EventControllerScrollFlags.DISCRETE,
	});

	scrollCtrl.connect("scroll", (_ctrl, dx, dy) => {
		if (!hovered) return Gdk.EVENT_PROPAGATE;

		const state = _ctrl.get_current_event_state?.() ?? 0;
		const shift = (state & Gdk.ModifierType.SHIFT_MASK) !== 0;

		onScroll({ dx, dy, hovered, shift });

		return Gdk.EVENT_STOP;
	});

	scrollCtrl.set_propagation_phase(Gtk.PropagationPhase.BUBBLE);
	box.add_controller(scrollCtrl);
}
