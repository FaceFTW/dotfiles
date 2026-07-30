using AstalWp;

[GtkTemplate(ui="/bar/volume/VolumeWidget.ui")]
class VolumeWidget: Gtk.Box {

    [GtkChild] unowned Gtk.Image volume_icon;
    [GtkChild] unowned Gtk.Popover volume_popover;
    [GtkChild] unowned VolumePopover volume_popover_contents;

    private AstalWp.Endpoint? speaker;

    public VolumeWidget() { Object(); }
    construct {
        this.speaker = Wp.get_default()?.get_default_speaker();

        this.speaker.bind_property(
            "volume-icon",
            this.volume_icon, "icon-name",
            BindingFlags.SYNC_CREATE
        );
    }

}

[GtkTemplate(ui="/bar/volume/VolumePopover.ui")]
class VolumePopover : Gtk.Box {
    public AstalWp.Endpoint? default_speaker { get; set; }

    [GtkChild] unowned Gtk.DropDown outputs_list;
    [GtkChild] unowned Gtk.Image volume_icon;
    [GtkChild] unowned Gtk.Scale volume_slider;

    private AstalWp.Wp wireplumber;

    public VolumePopover() { Object(); }
    construct {
        this.wireplumber = Wp.get_default();

        this.wireplumber.bind_property(
            "default-speaker",
            this, "default-speaker",
            BindingFlags.SYNC_CREATE
        );

        this.default_speaker.bind_property(
            "volume-icon",
            this.volume_icon, "icon-name",
            BindingFlags.SYNC_CREATE
        );

        this.volume_slider.set_range(0.0, 1.0);
        this.default_speaker.notify["volume"].connect((_) => {
            this.volume_slider.set_value(this.default_speaker.volume);
        });
        this.volume_slider.set_value(this.default_speaker.volume);
        this.volume_slider.value_changed.connect((_) => {
            this.default_speaker.volume = this.volume_slider.get_value();
        });

        // this.outputs_list.list_factory = new Gtk.SignalListItemFactory();
        // this.outputs_list.list_factory.setup.connect((_, item) => {
        //     var label = new Gtk.Label();
        //     label.xalign = 0;
        //     label.hexpand = true;
        //     ((Gtk.ListItem) item).set_child(label);
        // });
        // this.outputs_list.list_factory.bind.connect((_, item) => {
        //     var label = ((Gtk.ListItem) item).get_child();
        //     var stringObject = (Gtk.StringObject) ((Gtk.ListItem) item).get_item();
        //     label.set_label(stringObject.get_string());
        // });
    }
}

// [GtkTemplate(ui="/bar/volume/VolumeStreamWidget.ui")]
// class VolumeStreamWidget< : Gtk.Box {

//     [GtkChild] unowned Gtk.Image source_icon;
//     [GtkChild] unowned Gtk.Label source_label;
//     [GtkChild] unowned Gtk.Slider source_slider;

//     private AstalWp.Stream stream;

//     public VolumeWidget(AstalWp.Stream s) { Object(stream: s); }
//     construct {

//     }

// }
