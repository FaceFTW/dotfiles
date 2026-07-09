using AstalNetwork;

[GtkTemplate(ui = "/bar/network/NetworkButton.ui")]
class NetworkWidget : Gtk.Button {

    [GtkChild] public unowned Gtk.Image status_icon;
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


        ////////////////////////////////////
        // STATE INIT
        ////////////////////////////////////
        network_manager.notify["primary"].connect((s,p) => {
            if (this.icon_binding != null){
                this.icon_binding.unbind();
                //Should be freed here
            };

            switch (network_manager.primary){
                case AstalNetwork.Primary.WIRED:
                    if (this.network_manager.wired != null){
                        this.icon_binding = network_manager.wired.bind_property(
                            "icon_name",
                            this.status_icon,
                            "icon_name",
                            BindingFlags.DEFAULT
                        );
                    }
                    break;
                case AstalNetwork.Primary.WIFI:
                if (this.network_manager.wifi != null){
                    this.icon_binding = network_manager.wifi.bind_property(
                        "icon_name",
                        this.status_icon,
                        "icon_name",
                        BindingFlags.DEFAULT
                    );
                }
                    break;
                default:
                    //No binding
                    break;

            }
        });

        ////////////////////////////////////
        // SIGNALS WIRING
        ////////////////////////////////////
    }

}

[GtkTemplate(ui="/bar/network/NetworkPopup.ui")]
private class NetworkPopup : Gtk.Box {



    public NetworkPopup(){
        Object();
    }

    construct {

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
