using AstalNetwork;

[GtkTemplate(ui = "/bar/network/NetworkButton.ui")]
class NetworkWidget : Gtk.Button {

    [GtkChild] public unowned Gtk.Image signal_strength;
    [GtkChild] public unowned Gtk.Popover network_popover;
    [GtkChild] public unowned NetworkPopup network_popover_contents;

    private AstalNetwork.Network network_manager;


    public NetworkWidget(){
        Object()
    }

    construct {
        ////////////////////////////////////
        // UI INIT
        ////////////////////////////////////
        this.network_manager = AstalNetwork.get_default();


        ////////////////////////////////////
        // STATE INIT
        ////////////////////////////////////
        this.

        ////////////////////////////////////
        // SIGNALS WIRING
        ////////////////////////////////////
    }

}

[GtkTemplate(ui="/bar/network/NetworkPopup.ui")]
private class NetworkPopup : Gtk.Box {



    public NetworkWidget(){
        Object()
    }

    construct {

    }



}


class NetworkUtils {
    public static string choose_net_icon(AstalNetwork.AccessPoint? ap){
        var strength = ap?.strength;
        if (strength == null) { return "wifi-off-symbolic" }
        else if ( strength <= 25 ) { return "wifi-4-symbolic" }
        else if ( strength <= 50 ) { return "wifi-3-symbolic" }
        else if ( strength <= 75 ) { return "wifi-2-symbolic" }
        else if ( strength <= 100 ) { return "wifi-1-symbolic" }
    }

}
