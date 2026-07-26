using AstalWp;

[GtkTemplate(ui="/bar/volume/VolumeWidget.ui")]
class VolumeWidget: Gtk.Box {

    [GtkChild] unowned Gtk.Image volume_icon;

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
class VolumePopover: Gtk.Box {

}
