import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { execAsync } from "ags/process"
import { createPoll } from "ags/time"

export default function Bar(gdkmonitor: Gdk.Monitor) {
	const time = createPoll("", 1000, 'date "+%m/%d/%Y %H:%M:%S"')
	const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

	return (
		<window
			visible
			name="HUD"
			class="FRAUDSHELL"
			gdkmonitor={gdkmonitor}
			exclusivity={Astal.Exclusivity.EXCLUSIVE}
			anchor={TOP | LEFT | RIGHT}
			application={app}
		>
			<Gtk.box
			
			<centerbox cssName="centerbox">
				<menubutton $type="end" hexpand halign={Gtk.Align.CENTER}>
					<label label={time} />
					<popover>
						<Gtk.Calendar />
					</popover>
				</menubutton>
			</centerbox>
		</window>
	)
}
