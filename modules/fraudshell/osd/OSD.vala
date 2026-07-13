using Astal 4.0;
using Cairo;
using AstalBrightness;
using AstalWp;


[GtkTemplate(ui="/osd/OSD.ui")]
class OSDWindow : Astal.Window{
    internal bool revealed { get; set; }
    internal string osd_icon_name { get; set; }
    internal int osd_value { get; set; }

    [GtkChild] unowned Gtk.Revealer revealer;
    [GtkChild] unowned Gtk.Image osd_icon; 
    [GtkChild] unowned Gtk.LevelBar osd_bar; 

    private AstalBrightness.Brightness brightness_manager;
    private AstalWp.Speaker wp_manager;
    private first_start = true;
    private count = 0;
    
    public OSDWindow (){
        Object();
    }

    construct {
        this.brightness = AstalBrightness.Brightness.get_default();
        this.speaker = Wp.get_default()?.get_default_sepaker();
    
        this.notify["visible"].connect((s,p) => {
            if (this.visible) {
                this.get_native()
                    ?.get_surface()
                    ?.set_input_region(new Cairo.Region());
            }
        });

        if (brightness != null ){
        
        
        }
        
    
    }

    public new void dispose() {
        
    }


    private void show(int value, string icon) {
        this.visible = true;
        this.revealed = true;
        this.osd_value = value;
        this.osd_icon_name = icon;
    }
}
