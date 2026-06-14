import { Gdk, Gtk } from "ags/gtk4"
import { createBinding, createComputed, For, Accessor } from "ags"
import { config, theme } from "@/options"
import {
	attachHoverScroll,
	getAppInfo,
	truncateByFormat,
} from "@/src/lib/utils"
import { icons } from "@/src/lib/icons"
import BarItem, { FunctionsList } from "@/src/widgets/baritem"
import { isVertical, orientation } from "../bar"

import AstalHyprland from "gi://AstalHyprland?version=0.1"
import { bash } from "@/src/lib/utils"
import GLib from "gi://GLib?version=2.0"

const compositorName = GLib.getenv("XDG_CURRENT_DESKTOP")!.toLowerCase()
const hyprland =
	compositorName === "hyprland" ? AstalHyprland.get_default() : null

const compositor = {
	name() {
		return compositorName
	},
	workspaces(): Accessor<any[]> {
		return createBinding(hyprland, "workspaces").as((ws) =>
			ws.sort((a, b) => a.id - b.id),
		)
	},
	monitorWorkspaces(gdkmonitor: Gdk.Monitor): Accessor<any[]> {
		const model = gdkmonitor.model
		return createBinding(hyprland, "workspaces").as((workspaces) =>
			workspaces
				.filter((ws) => ws.monitor?.model === model)
				.sort((a, b) => a.id - b.id),
		)
	},
	focusedWorkspace(): Accessor<any> {
		return createBinding(hyprland, "focusedWorkspace")
	},
	focusedWindow(): Accessor<any> {
		return createBinding(hyprland, "focusedClient")
	},
	workspaceId(ws: any): number {
		if (!ws) {
			return 0
		}

		return ws.id || 0
	},
	workspaceName(ws: any): string {
		return ws?.name || ""
	},
	workspaceWindows(ws: any): Accessor<any[]> {
		if (!ws) {
			return { get: () => [], subscribe: () => () => {} } as any
		}

		return createBinding(ws, "clients")
	},
	focusWorkspace(ws: any) {
		ws?.focus()
	},
	nextWorkspace() {
		bash("hyprctl dispatch workspace +1")
	},
	previousWorkspace() {
		bash("hyprctl dispatch workspace -1")
	},
	windowId(win: any): number | string {
		if (!win) {
			return 0
		}
		return win.pid || 0
	},
	windowClass(win: any): string {
		if (!win) {
			return ""
		}

		return win.class || ""
	},
	windowTitle(win: any): string {
		return win?.title || ""
	},
	focusWindow(win: any) {
		if (!win) {
			return
		}

		win.focus()
	},
	closeWindow(win: any) {
		if (!win) {
			return
		}

		win.kill()
	},
}

export function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const conf = config.bar.modules.workspaces
	const workspaces = compositor.monitorWorkspaces(gdkmonitor)
	const focusedWorkspace = compositor.focusedWorkspace()
	const focusedWindow = compositor.focusedWindow()

	function AppButton({ window: win }: { window: any }) {
		const appsIcons = conf["taskbar-icons"]
		const windowClass = compositor.windowClass(win)
		const appInfo = getAppInfo(windowClass)
		const iconName =
			appsIcons[windowClass] || appInfo?.iconName || icons.apps_default

		const title = createBinding(win, "title")

		const classes = focusedWindow((focused) => {
			const classes = ["taskbar-button"]
			if (
				focused &&
				compositor.windowId(focused) === compositor.windowId(win)
			) {
				classes.push("focused")
			}
			return classes
		})

		const hasIndicator = conf["window-format"].includes("{indicator}")
		const formatWithoutIndicator = conf["window-format"]
			.replace(/\{indicator\}\s*/g, "")
			.trim()
		const mainFormat = formatWithoutIndicator
			? formatWithoutIndicator
			: "{icon}"

		const indicatorValign =
			config.bar.position === "top"
				? Gtk.Align.START
				: config.bar.position === "bottom"
					? Gtk.Align.END
					: Gtk.Align.CENTER

		const indicatorHalign =
			config.bar.position === "left"
				? Gtk.Align.START
				: config.bar.position === "right"
					? Gtk.Align.END
					: Gtk.Align.CENTER

		return (
			<overlay hexpand={isVertical} cssClasses={classes}>
				{hasIndicator && (
					<box
						$type="overlay"
						class="indicator"
						valign={indicatorValign}
						halign={indicatorHalign}
						vexpand
						hexpand
					/>
				)}
				<BarItem
					format={mainFormat}
					onPrimaryClick={() => compositor.focusWindow(win)}
					onMiddleClick={() => compositor.closeWindow(win)}
					data={{
						icon: (
							<image
								iconName={iconName}
								pixelSize={conf["window-icon-size"]}
								hexpand={isVertical}
							/>
						),
						title: (
							<label
								label={title((t) => truncateByFormat(t, "title", mainFormat))}
								hexpand={isVertical}
							/>
						),
						name: (
							<label
								label={truncateByFormat(
									appInfo?.name.trim() || windowClass,
									"name",
									mainFormat,
								)}
								hexpand={isVertical}
							/>
						),
					}}
					tooltipText={title}
				/>
			</overlay>
		)
	}

	function WorkspaceButton({ ws }: { ws: any }) {
		const windows = compositor.workspaceWindows(ws)
		const windowCount = windows((w) => w.length)

		const visible = createComputed(() => {
			if (conf["hide-empty"]) {
				const focused = focusedWorkspace()
				return (
					windowCount() > 0 ||
					(focused &&
						compositor.workspaceId(focused) === compositor.workspaceId(ws))
				)
			}
			return true
		})

		const classNames = focusedWorkspace((fws) => {
			const classes = ["bar-item", "workspace"]
			if (fws && compositor.workspaceId(fws) === compositor.workspaceId(ws)) {
				classes.push("active")
			}
			if (!conf["workspace-format"].includes("{windows}"))
				classes.push("minimal")
			if (windowCount() === 0) classes.push("empty")
			return classes
		})

		return conf["workspace-format"] === "" ? (
			<box
				cssClasses={classNames}
				valign={Gtk.Align.CENTER}
				halign={Gtk.Align.CENTER}
				visible={visible}
			>
				<Gtk.GestureClick
					onPressed={(ctrl) => {
						const button = ctrl.get_current_button()
						if (button === Gdk.BUTTON_PRIMARY) compositor.focusWorkspace(ws)
					}}
				/>
			</box>
		) : (
			<BarItem
				cssClasses={classNames}
				onPrimaryClick={() => compositor.focusWorkspace(ws)}
				format={conf["workspace-format"]}
				visible={visible}
				data={{
					id: (
						<label
							label={compositor.workspaceId(ws).toString()}
							hexpand={isVertical}
						/>
					),
					name: (
						<label label={compositor.workspaceName(ws)} hexpand={isVertical} />
					),
					count: (
						<label
							label={windowCount((c) => c.toString())}
							hexpand={isVertical}
						/>
					),
					windows: (
						<box
							orientation={orientation}
							spacing={theme.bar.spacing}
							visible={windowCount((c) => c > 0)}
						>
							<For each={windows}>
								{(win: any) => <AppButton window={win} />}
							</For>
						</box>
					),
				}}
			/>
		)
	}

	return (
		<box
			spacing={theme.bar.spacing}
			orientation={orientation}
			hexpand={isVertical}
			cssClasses={[
				"workspaces",
				conf["workspace-format"] === "" ? "compact" : "",
			]}
			$={(self) =>
				attachHoverScroll(self, ({ dy }) => {
					if (dy < 0) {
						FunctionsList[conf["on-scroll-up"] as keyof typeof FunctionsList]()
					} else if (dy > 0) {
						FunctionsList[
							conf["on-scroll-down"] as keyof typeof FunctionsList
						]()
					}
				})
			}
		>
			{conf["workspace-format"] === "" ? (
				<box
					class="content"
					orientation={orientation}
					spacing={theme.bar.spacing}
				>
					<For each={workspaces}>{(ws) => <WorkspaceButton ws={ws} />}</For>
				</box>
			) : (
				<For each={workspaces}>{(ws) => <WorkspaceButton ws={ws} />}</For>
			)}
		</box>
	)
}
