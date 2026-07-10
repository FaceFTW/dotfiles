[GtkTemplate(ui="/bar/Bar.ui")]
class Bar : Astal.Window {
    public string clock { get; set; }
    public uint interval;

    public string volume_icon { get; set; }
    public string battery_visible { get; set; }
    public string battery_label { get; set; }
    public string battery_icon { get; set; }
    public double volume { get; set; }
    public string power_profile_icon { get; set; }
    public bool bluetooth_visible { get; set; }

    [GtkChild] unowned Gtk.Popover popover;
    [GtkChild] unowned Gtk.Calendar calendar;
    [GtkChild] unowned WorkspacesWidget workspaces;
    [GtkChild] unowned TrayWidget tray;
    [GtkChild] unowned NetworkWidget network;

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

        // battery
        var bat = AstalBattery.get_default();
        bat.bind_property("is-present", this, "battery-visible", BindingFlags.SYNC_CREATE);
        bat.bind_property("icon-name", this, "battery-icon", BindingFlags.SYNC_CREATE);
        bat.bind_property("percentage", this, "battery-label", BindingFlags.SYNC_CREATE, (_, src, ref target) => {
            target.set_string(@"$(Math.floor(bat.percentage * 100))%");
            return true;
        }, null);

        // volume
        var speaker = AstalWp.get_default().get_default_speaker();
        speaker.bind_property("volume-icon", this, "volume-icon", BindingFlags.SYNC_CREATE);
        speaker.bind_property("volume", this, "volume", BindingFlags.SYNC_CREATE);

        // powerprofiles
        var powerprofile = AstalPowerProfiles.get_default();
        powerprofile.bind_property("icon-name", this, "power-profile-icon", BindingFlags.SYNC_CREATE);

        // bluetooth
        var bt = AstalBluetooth.get_default();
        bt.bind_property("is-connected", this, "bluetooth-visible", BindingFlags.SYNC_CREATE);
    }

    [GtkCallback]
    bool change_volume(Gtk.Range scale, Gtk.ScrollType type, double value) {
        AstalWp.get_default().get_default_speaker().set_volume(value);
        return true;
    }

    public override void dispose() {
        Source.remove(interval);
        base.dispose();
    }


}
