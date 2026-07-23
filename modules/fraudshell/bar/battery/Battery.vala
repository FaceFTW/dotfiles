using AstalBattery;
using AstalPowerProfiles;

[GtkTemplate(ui="/bar/battery/BatteryWidget.ui")]
class BatteryWidget : Gtk.Box {

    [GtkChild] unowned Gtk.MenuButton battery_button;
    [GtkChild] unowned Gtk.Image power_profile_icon;
    [GtkChild] unowned Gtk.Image battery_icon;
    [GtkChild] unowned Gtk.Label battery_percent;
    [GtkChild] unowned PowerMenuPopover power_popover_contents;

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

[GtkTemplate(ui = "/bar/battery/PowerMenuPopover.ui")]
class PowerMenuPopover: Gtk.Box {

    [GtkChild] unowned Gtk.Button power_saver_button;
    [GtkChild] unowned Gtk.Image power_saver_active;
    [GtkChild] unowned Gtk.Button balanced_button;
    [GtkChild] unowned Gtk.Image balanced_active;
    [GtkChild] unowned Gtk.Button performance_button;
    [GtkChild] unowned Gtk.Image performance_active;

    [GtkChild] unowned Gtk.Label energy_rate;
    [GtkChild] unowned Gtk.Label capacity;
    [GtkChild] unowned Gtk.Label health;

    private AstalBattery.Device battery_manager;
    private AstalPowerProfiles.PowerProfiles power_manager;

    public PowerMenuPopover() {
        Object ();
    }

    construct {
        this.battery_manager = AstalBattery.get_default();
        this.power_manager = AstalPowerProfiles.get_default();


        this.power_manager.notify["active-profile"].connect((_) => {
            var profile = this.power_manager.active_profile;

            this.power_saver_active.visible = (profile == "power-saver");
            this.balanced_active.visible = (profile == "balanced");
            this.performance_active.visible = (profile == "performance");
        });

        this.power_saver_button.clicked.connect(() => this.power_manager.active_profile = "power-saver");
        this.balanced_button.clicked.connect(() => this.power_manager.active_profile = "balanced");
        this.performance_button.clicked.connect(() => this.power_manager.active_profile = "performance");

        Timeout.add (200, () => {
            string energy_rate_val = "%.2f".printf(this.battery_manager.energy_rate);
            string energy_val = "%.2f".printf(this.battery_manager.energy);
            string energy_full_val =  "%.2f".printf(this.battery_manager.energy_full);
            string health_val = "%.2f".printf(this.battery_manager.energy_full / this.battery_manager.energy_full_design);

            if (battery_manager.charging) {
                this.energy_rate.label = @"Charge Rate: $(energy_rate_val)W - $(this.battery_manager.time_to_full)s to full";
            } else {
                this.energy_rate.label = @"Charge Rate: $(energy_rate_val)W";
            }

            this.capacity.label = @"Capacity: $(energy_val)Wh / $(energy_full_val)Wh";
            this.health.label = @"Health: $(health_val)%";
            return Source.CONTINUE;
        }, Priority.DEFAULT);
    }
}
