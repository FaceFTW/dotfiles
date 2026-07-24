[GtkTemplate(ui="/bar/tray/Tray.ui")]
class TrayWidget: Gtk.Box {

    [GtkChild] private unowned Gtk.FlowBox tray_box;

    private AstalTray.Tray tray_manager;
    private GLib.ListStore tray_items;

    public TrayWidget(){ Object(); }
    construct {
        ////////////////////////////////////
        // UI INIT
        ////////////////////////////////////
        this.tray_manager = AstalTray.get_default();
        this.tray_items = new GLib.ListStore(typeof (TrayItem));

        this.tray_box.set_layout_manager(new Gtk.BoxLayout(Gtk.Orientation.HORIZONTAL));
        this.tray_box.bind_model(
            tray_items,
            (x) => { return new TrayButton((TrayItem) x); }
        );

        ////////////////////////////////////
        // STATE INIT
        ////////////////////////////////////

        ////////////////////////////////////
        // SIGNALS WIRING
        ////////////////////////////////////
        this.tray_manager.item_added.connect(on_tray_item_added);
        this.tray_manager.item_removed.connect(on_tray_item_removed);
    }

    public override void dispose(){
        this.tray_manager.item_added.disconnect(on_tray_item_added);
        this.tray_manager.item_removed.disconnect(on_tray_item_removed);
    }

    private void on_tray_item_added(string id){
        this.tray_items.append(new TrayItem(id));
    }

    private void on_tray_item_removed(string id){
        uint pos = 0;
        if (this.tray_items.find_with_equal_func(
                new TrayItem(id),
                (a, b) => { return ((TrayItem) a).id == ((TrayItem) b).id; },
                out pos
            )){
                this.tray_items.remove(pos);
        }
    }


    private class TrayButton : Gtk.Button {
        AstalTray.TrayItem item;
        Gtk.Popover popover;
        Gtk.Image image;

        public TrayButton(TrayItem ti) {
            var tray = AstalTray.get_default();
            item = tray.get_item(ti.id);

            image = new Gtk.Image();
            popover = new Gtk.PopoverMenu.from_model(item.menu_model);

            child = new Gtk.MenuButton() {
                child = image,
                popover = popover,
            };

            item.bind_property("gicon", image, "gicon", BindingFlags.SYNC_CREATE);
            popover.insert_action_group("dbusmenu", item.action_group);
            item.notify["action-group"].connect(on_action_group);
        }

        void on_action_group() {
            popover.insert_action_group("dbusmenu", item.action_group);
        }

        public override void dispose() {
            item.notify.disconnect(on_action_group);
        }
    }

    /**
    * Stupid wrapper around primitives so it can become a GObject
    * and work in GListStore because strings aren't GObjects (obviously)
    */
    private class TrayItem : Object {
        public string id { get; construct; }

        public TrayItem(string id){
            Object(id: id);
        }
    }
}
