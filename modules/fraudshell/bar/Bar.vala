[GtkTemplate(ui="/bar/Bar.ui")]
class Bar : Astal.Window {
    public string clock { get; set; }
    public uint interval;

    // public string volume_icon { get; set; }
    // public string battery_visible { get; set; }
    // public string battery_label { get; set; }
    // public string battery_icon { get; set; }
    // public double volume { get; set; }
    // public string power_profile_icon { get; set; }
    // public bool bluetooth_visible { get; set; }

    [GtkChild] unowned Gtk.Popover popover;
    [GtkChild] unowned Gtk.Calendar calendar;
    [GtkChild] unowned WorkspacesWidget workspaces;
    [GtkChild] unowned TrayWidget tray;
    // [GtkChild] unowned NetworkWidget network;

    public Bar() {
        Object();
    }

    construct{
        anchor = TOP | LEFT | RIGHT;
        exclusivity = EXCLUSIVE;
        present();

        clock = new DateTime.now_local().format("%m/%d/%Y  %H:%M:%S");
        interval = Timeout.add(1000, () => {
            clock = new DateTime.now_local().format("%m/%d/%Y  %H:%M:%S");
            return Source.CONTINUE;
        }, Priority.DEFAULT);

        popover.notify["visible"].connect(() => {
            if (popover.visible) {
                calendar.select_day(new DateTime.now_local());
            }
        });

    }


    public override void dispose() {
        Source.remove(interval);
        base.dispose();
    }


}
