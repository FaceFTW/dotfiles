using Astal;
using Cairo;
using AstalBrightness;
using AstalWp;

[GtkTemplate(ui="/osd/OSD.ui")]
class OSDWindow : Astal.Window{
    internal bool revealed { get; set; }
    internal string osd_icon_name { get; set; }
    internal uint osd_value { get; set; }

    [GtkChild] unowned Gtk.Revealer revealer;
    [GtkChild] unowned Gtk.Image osd_icon;
    [GtkChild] unowned Gtk.LevelBar osd_bar;

    private AstalBrightness.Brightness brightness_manager;
    private AstalWp.Endpoint? speaker;
    private bool first_start = true;
    private uint count = 0;
    private uint osd_timeout;

    public OSDWindow (){
        Object();
    }

    construct {
        this.brightness_manager = AstalBrightness.Brightness.get_default();
        this.speaker = Wp.get_default()?.get_default_speaker();

        this.notify["visible"].connect((s,p) => {
            if (this.visible) {
                this.get_native()
                    ?.get_surface()
                    ?.set_input_region(new Cairo.Region());
            }
        });

        if (brightness_manager != null){
            brightness_manager.screen.notify["real-brightness"].connect((_) => {
                show(brightness_manager.screen.real_brightness, "sun-symbolic");
            });
        }
        // } else { GLib.warn("OSD: Brightness monitoring unavailable"); }


        Timeout.add(500, () => {
            this.first_start = false;
            return Source.REMOVE;
        }, Priority.DEFAULT);

        if (this.speaker != null){
            this.speaker.notify["volume"].connect((_) => {
                if (this.first_start) { return; }

                show((uint)(this.speaker.volume), this.speaker.volume_icon);

            });
        }
    }

    public new void dispose() {

    }


    private void show(uint value, string icon) {
        this.visible = true;
        this.revealed = true;
        this.osd_value = value;
        this.osd_icon_name = icon;

        if (this.osd_timeout != -1){
            this.osd_timeout = Timeout.add(200, () => {
                this.count--;
                if (count == 0){
                    this.revealed = false;
                    this.osd_timeout = -1;
                    return Source.REMOVE;
                }
                return Source.CONTINUE;
            }, Priority.DEFAULT);
        }
    }
}
