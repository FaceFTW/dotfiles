import AstalHyprland from "gi://AstalHyprland?version=0.1";
import { createBinding, Accessor } from "ags";
import { bash } from "@/src/lib/utils";
import GLib from "gi://GLib?version=2.0";
import { LayoutKeys, layoutMap, LayoutValues } from "./keyboardLayouts";
import { Gdk } from "ags/gtk4";

const hyprland = AstalHyprland.get_default();

export const compositor = {
	name() {
		return compositorName;
	},
	workspaces(): Accessor<any[]> {
		return createBinding(hyprland, "workspaces").as((ws) =>
			ws.sort((a, b) => a.id - b.id),
		);
	},
	monitorWorkspaces(gdkmonitor: Gdk.Monitor): Accessor<any[]> {
		const model = gdkmonitor.model;
		return createBinding(hyprland, "workspaces").as((workspaces) =>
			workspaces
				.filter((ws) => ws.monitor?.model === model)
				.sort((a, b) => a.id - b.id),
		);
	},
	focusedWorkspace(): Accessor<any> {
		return createBinding(hyprland, "focusedWorkspace");
	},
	focusedWindow(): Accessor<any> {
		return createBinding(hyprland, "focusedClient");
	},
	workspaceId(ws: any): number {
		if (!ws) return 0;

		return ws.id || 0;
	},
	workspaceName(ws: any): string {
		return ws?.name || "";
	},
	workspaceWindows(ws: any): Accessor<any[]> {
		if (!ws) return { get: () => [], subscribe: () => () => {} } as any;

		return createBinding(ws, "clients");
	},
	focusWorkspace(ws: any) {
		ws?.focus();
	},
	nextWorkspace() {
		bash("hyprctl dispatch workspace +1");
	},
	previousWorkspace() {
		bash("hyprctl dispatch workspace -1");
	},
	windowId(win: any): number | string {
		if (!win) return 0;

		return win.pid || 0;
	},
	windowClass(win: any): string {
		if (!win) return "";

		return win.class || "";
	},
	windowTitle(win: any): string {
		return win?.title || "";
	},
	focusWindow(win: any) {
		if (!win) return;

		win.focus();
	},
	closeWindow(win: any) {
		if (!win) return;

		win.kill();
	},
	keyboard: {
		async getLayout(): Promise<{ full: string; short: string }> {
			try {
				const json = await bash(`hyprctl devices -j`);
				const devices = JSON.parse(json);
				let mainKb = devices.keyboards.find((kb: any) => kb.main);

				if (!mainKb) {
					mainKb = devices[devices.length - 1];
				}

				if (!this.isValidLayout(mainKb.active_keymap)) {
					return {
						full: layoutMap["Unknown Layout"],
						short: "?",
					};
				}

				const layout: LayoutKeys = mainKb.active_keymap;
				const foundLayout: LayoutValues = layoutMap[layout];
				return {
					full: layout,
					short: foundLayout,
				};
			} catch (error) {
				console.error("Failed to get keyboard layout:", error);
			}
			return { full: "Unknown", short: "?" };
		},
		onLayoutChange(callback: () => void): () => void {
			const id = hyprland.connect("keyboard-layout", callback);
			return () => hyprland.disconnect(id);
		},
		async switchLayout() {
			try {
				const json = await bash(`hyprctl devices -j`);
				const devices = JSON.parse(json);
				let mainKb = devices.keyboards.find((kb: any) => kb.main);

				if (mainKb.name) {
					bash(`hyprctl switchxkblayout ${mainKb.name} next`);
				}
			} catch (error) {
				console.error("Failed to switch keyboard layout:", error);
			}
		},
		isValidLayout(kbLayout: string): kbLayout is LayoutKeys {
			return Object.keys(layoutMap).includes(kbLayout);
		},
	},
};
