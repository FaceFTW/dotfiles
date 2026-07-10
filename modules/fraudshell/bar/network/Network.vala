using AstalNetwork;

[GtkTemplate(ui = "/bar/network/NetworkButton.ui")]
class NetworkWidget : Gtk.Box {
    [GtkChild] public unowned Gtk.MenuButton network_button;
    [GtkChild] public unowned Gtk.Image network_status_icon;
    [GtkChild] public unowned Gtk.Popover network_popover;
    [GtkChild] public unowned NetworkPopup network_popover_contents;

    private AstalNetwork.Network network_manager;
    private Binding icon_binding;


    public NetworkWidget(){
        Object();
    }

    construct {
        ////////////////////////////////////
        // UI INIT
        ////////////////////////////////////
        this.network_manager = AstalNetwork.get_default();
        this.set_layout_manager(new Gtk.BinLayout());

        ////////////////////////////////////
        // STATE INIT
        ////////////////////////////////////
        network_manager.bind_property(
            "primary",
            this.network_status_icon,
            "icon-name",
            BindingFlags.SYNC_CREATE,
            (_, primary) => {
                if (this.icon_binding != null){
                    this.icon_binding.unbind();
                    //Should be freed here
                };

                switch (primary.get_enum()) {
                    case AstalNetwork.Primary.WIRED:
                        if (this.network_manager.wired != null){
                            this.icon_binding = network_manager.wired.bind_property(
                                "icon-name",
                                this.network_status_icon,
                                "icon-name",
                                BindingFlags.SYNC_CREATE
                            );
                        }
                        return false;
                    case AstalNetwork.Primary.WIFI:
                        if (this.network_manager.wifi != null){
                            this.icon_binding = network_manager.wifi.bind_property(
                                "icon-name",
                                this.network_status_icon,
                                "icon-name",
                                BindingFlags.SYNC_CREATE
                            );
                        }
                        return false;
                    default:
                        //No binding
                        break;
                }
        });

        ////////////////////////////////////
        // SIGNALS WIRING
        ////////////////////////////////////
        // this.clicked.connect((s) => {
        //     this.network_popover.popup();
        // });
    }



}

[GtkTemplate(ui="/bar/network/NetworkPopup.ui")]
private class NetworkPopup : Gtk.Box {

    [GtkChild] unowned Gtk.Button refresh_button;
    [GtkChild] unowned Gtk.Switch wifi_toggle;
    [GtkChild] unowned Gtk.ListBox network_list;

    private AstalNetwork.Network network_manager;


    public NetworkPopup(){
        Object();
    }

    construct {

    }
}

[GtkTemplate(ui="/bar/network/NetworkPopupItem.ui")]
private class NetworkPopupItem: Gtk.Button {
    public AstalNetwork.AccessPoint access_point { get; construct; }

    [GtkChild] unowned Gtk.Image ap_strength;
    [GtkChild] unowned Gtk.Label ssid_label;
    [GtkChild] unowned Gtk.Image connected_check;

    private AstalNetwork.Network network;

    public NetworkPopupItem(AstalNetwork.AccessPoint ap ) {
        Object(access_point: ap);
    }

    construct {
        this.ap_strength.icon_name = this.access_point.icon_name;
        this.ssid_label.label = this.access_point.bssid;
        this.connected_check.visible = this.network.wifi?.ssid == this.access_point.bssid;
    }

}




// class NetworkUtils {
//     private string ethernet_icon = "ethernet-port-symbolic";
//     private string wifi_off_icon = "wifi-off-symbolic";
//     private string wifi_1_icon = "wifi-1-symbolic";
//     private string wifi_2_icon = "wifi-2-symbolic";
//     private string wifi_3_icon = "wifi-3-symbolic";
//     private string wifi_4_icon = "wifi-4-symbolic";



//     public static string choose_net_icon(AstalNetwork.Network network_manager){
//         if (network.primary == AstalNetwork.Primary.WIRED) {
//             if (network.wired.internet == AstalNetwork.Internet.CONNECTED) {
//                 return ethernet_icon;
//             }
//         }

//         if (network.primary == AstalNetwork.Primary.WIFI) {
//             if (!network.wifi.enabled || network.connectivity == AstalNetwork.Connectivity.NONE){
//                 return wifi_off_icon;
//             }

//             return choose_wifi_icon()
//         }
//     }

//     public static string choose_wifi_icon(AstalNetwork.AccessPoint? ap){
//         var strength = ap?.strength;
//         if (strength == null) { return wifi_off_icon; }
//         else if ( strength <= 25 ) { return wifi_4_icon; }
//         else if ( strength <= 50 ) { return wifi_3_icon; }
//         else if ( strength <= 75 ) { return wifi_2_icon; }
//         else if ( strength <= 100 ) { return wifi_1_icon; }
//     }

// }
