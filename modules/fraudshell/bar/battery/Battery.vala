using AstalBattery;
using AstalPowerProfiles;

[GtkTemplate(ui="/bar/battery/BatteryWidget.ui")]
class BatteryWidget : Gtk.Box {

    [GtkChild] unowned Gtk.MenuButton battery_button;
    [GtkChild] unowned Gtk.Image power_profile_icon;
    [GtkChild] unowned Gtk.Image battery_icon;
    [GtkChild] unowned Gtk.Label battery_percent;


    private AstalBattery.Device battery_manager;
    private AstalPowerProfiles.PowerProfiles power_manager;

    public BatteryWidget() {
        Object ();
    }

    construct {
        this.battery_manager = AstalBattery.get_default();
        this.power_manager = AstalPowerProfiles.get_default();

        this.power_manager.bind_property(
            "icon-name",
            this.power_profile_icon,
            "icon-name",
            BindingFlags.SYNC_CREATE
        );

        this.battery_manager.bind_property(
            "icon-name",
            this.battery_icon,
            "icon-name",
            BindingFlags.SYNC_CREATE
        );

        this.battery_manager.bind_property(
            "percentage",
            this.battery_percent,
            "label",
            BindingFlags.SYNC_CREATE,
            (_, x) => {
                double percent = ((double) x) * 100.0;
                this.battery_percent.label = @"$percent%";
            }
        );




    }
}
