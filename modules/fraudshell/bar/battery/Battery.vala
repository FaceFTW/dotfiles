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

    public BatteryWidget() { Object (); }
    construct {
        this.battery_manager = AstalBattery.get_default();
        this.power_manager = AstalPowerProfiles.get_default();

        this.power_manager.bind_property(
            "icon-name",
            this.power_profile_icon, "icon-name",
            BindingFlags.SYNC_CREATE
        );

        this.battery_manager.bind_property(
            "icon-name",
            this.battery_icon, "icon-name",
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

    public string energy_rate_str { get; private set; }
    [GtkChild] unowned Gtk.Label energy_rate;
    public string capacity_str { get; private set; }
    [GtkChild] unowned Gtk.Label capacity;

    private uint interval;
    private AstalBattery.Device battery_manager;
    private AstalPowerProfiles.PowerProfiles power_manager;

    public PowerMenuPopover() { Object(); }
    construct {
        this.battery_manager = AstalBattery.get_default();
        this.power_manager = AstalPowerProfiles.get_default();

        this.power_manager.notify["active-profile"].connect(update_active_profile_check);
        update_active_profile_check();

        this.power_saver_button.clicked.connect(() => {
            info("Setting power profile to power-saver");
            this.power_manager.active_profile = "power-saver";
        });
        this.balanced_button.clicked.connect(() => {
            info("Setting power profile to balanced");
            this.power_manager.active_profile = "balanced";
        });
        this.performance_button.clicked.connect(() => {
            info("Setting power profile to performance");
            this.power_manager.active_profile = "performance";
        });

        this.bind_property(
            "energy-rate-str",
            this.energy_rate, "label",
            BindingFlags.SYNC_CREATE
        );

        this.bind_property(
            "capacity-str",
            this.capacity, "label",
            BindingFlags.SYNC_CREATE
        );

        this.interval = Timeout.add (1000, () => {
        //TODO bind to properties
            string energy_rate_val = "%.2f".printf(this.battery_manager.energy_rate);
            string energy_val = "%.2f".printf(this.battery_manager.energy);
            string energy_full_val =  "%.2f".printf(this.battery_manager.energy_full);

            if (battery_manager.charging) {
                this.energy_rate_str = @"Charge Rate: $(energy_rate_val)W - $(this.battery_manager.time_to_full)s to full";
            } else {
                this.energy_rate_str = @"Charge Rate: $(energy_rate_val)W";
            }

            this.capacity_str= @"Capacity: $(energy_val)Wh / $(energy_full_val)Wh";

            return Source.CONTINUE;
        }, Priority.DEFAULT);
    }

    private void update_active_profile_check() {
        var profile = this.power_manager.active_profile;

        this.power_saver_active.visible = (profile == "power-saver");
        this.balanced_active.visible = (profile == "balanced");
        this.performance_active.visible = (profile == "performance");
    }

    public override void dispose(){
        Source.remove(this.interval);
        base.dispose();
    }
}
