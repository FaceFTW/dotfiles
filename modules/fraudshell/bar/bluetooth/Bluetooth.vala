using AstalBluetooth;

[GtkTemplate(ui="/bar/bluetooth/BluetoothWidget.ui")]
class BluetoothWidget : Gtk.Box {
    [GtkChild] Gtk.Button bluetooth_button;
    [GtkChild] Gtk.Image bluetooth_status_icon;

    private AstalBluetooth.Bluetooth bt_manager;

    public BluetoothWidget(){ Object(); }
    construct {
        this.bt_manager = AstalBluetooth.get_default();

        this.bt_manager.notify["is-powered"].connect(() => this.update_icon());
        this.bt_manager.notify["is-connected"].connect(() => this.update_icon());
        update_icon();

        this.bluetooth_button.clicked.connect(() => {
            this.bt_manager.toggle();
        });
    }

    private void update_icon(){
        if (this.bt_manager.is_powered) {
            if (this.bt_manager.is_connected) {
                this.bluetooth_status_icon.icon_name = "blueman-active-symbolic";
            } else {
                this.bluetooth_status_icon.icon_name = "blueman-tray-symbolic";
            }
        } else {
            this.bluetooth_status_icon.icon_name = "blueman-disabled-symbolic";
        }
    }

}
