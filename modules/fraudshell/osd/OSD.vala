using Astal;
using Cairo;
using AstalBrightness;
using AstalWp;

[GtkTemplate(ui="/osd/OSD.ui")]
class OSDWindow : Astal.Window{
    public string osd_icon_name { get; set; default = ""; }
    public double osd_value { get; set; default = 0; }

    [GtkChild] unowned Gtk.Revealer revealer;
    [GtkChild] unowned Gtk.Image osd_icon;
    [GtkChild] unowned Gtk.LevelBar osd_bar;

    private AstalBrightness.Brightness brightness_manager;
    private AstalWp.Endpoint? speaker;
    private bool first_start = true;
    private uint count = 0;
    private uint osd_timeout = -1;

    public OSDWindow (){
        Object();
    }

    construct {
        // present();

        this.brightness_manager = AstalBrightness.Brightness.get_default();
        this.speaker = Wp.get_default()?.get_default_speaker();

        // this.notify["visible"].connect((s,p) => {
        //     if (this.visible) {
        //         this.get_native()
        //             ?.get_surface()
        //             ?.set_input_region(new Cairo.Region());
        //     }
        // });

        if (brightness_manager != null){
            brightness_manager.screen.notify["brightness"].connect((_) => {
                show((double) brightness_manager.screen.brightness, "sun-symbolic");
            });
        } else { GLib.warning("OSD: Brightness monitoring unavailable"); }


        // Timeout.add(500, () => {
        //     this.first_start = false;
        //     return Source.REMOVE;
        // }, Priority.DEFAULT);

        // if (this.speaker != null){
        //     this.speaker.notify["volume"].connect((_) => {
        //         if (this.first_start) { return; }
        //         show(this.speaker.volume, this.speaker.volume_icon);
        //     });
        // }

        this.bind_property(
            "osd-value",
            this.osd_bar,
            "value",
            BindingFlags.SYNC_CREATE,
            (_, val) => { this.osd_bar.value = (double) val; }
        );
    }

    // public new void dispose() {

    // }


    private void show(double value, string icon) {
        this.visible = true;
        this.revealer.reveal_child = true;
        this.osd_value = value;
        this.osd_icon_name = icon;
        this.count ++;

        if (this.osd_timeout == -1){
            this.osd_timeout = Timeout.add(1000, () => {
                this.count--;
                if (count == 0){
                    this.osd_timeout = -1;
                    this.revealer.reveal_child = false;
                    this.visible = false;
                    return Source.REMOVE;
                }
                return Source.CONTINUE;
            }, Priority.DEFAULT);
        }
    }
}
