[GtkTemplate(ui="/bar/Bar.ui")]
class Bar : Astal.Window {
    public string clock { get; set; }
    public uint interval;

    [GtkChild] unowned Gtk.Popover popover;
    [GtkChild] unowned Gtk.Calendar calendar;
    [GtkChild] unowned WorkspacesWidget workspaces;
    [GtkChild] unowned TrayWidget tray;
    [GtkChild] unowned PerformanceWidget perf;
    [GtkChild] unowned NetworkWidget network;
    [GtkChild] unowned BatteryWidget battery;

    public Bar() { Object(); }
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
