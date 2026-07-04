using Gtk;
using Gdk;
using Astal;
using AstalHyprland;

class HyprClient : Object {
    public string class { get; construct; }
    public string address { get; construct; }

    public HyprClient(AstalHyprland.Client client) {
        Object( class: client.class, address: client.address );
    }

    public HyprClient.only_addr(string addr){
        Object (class: "", address: addr);
    }
}

[GtkTemplate (ui = "/bar/workspaces/Workspaces.ui")]
public class WorkspacesWidget : Gtk.Box {
    [GtkChild] public unowned Gtk.ScrolledWindow scrollbox;
    [GtkChild] public unowned Gtk.FlowBox content_box;

    private AstalHyprland.Hyprland compositor;

    public WorkspacesWidget() {
        Object();
    }

    construct {
        this.compositor = AstalHyprland.get_default();
        this.scrollbox.set_policy(PolicyType.NEVER, PolicyType.NEVER);
        this.content_box.set_layout_manager(new Gtk.BoxLayout(Gtk.Orientation.HORIZONTAL));

        var workspaces = compositor.workspaces;
        workspaces.sort((a, b) => {
            return (int) (a.id > b.id) - (int) (a.id < b.id);
        });

        foreach (var ws in workspaces) {
            var button = new WorkspaceButton(ws);
            content_box.append(button);
        }

        // Listen for workspace changes
        compositor.notify["focused-workspace"].connect(
            on_focused_workspace_changed
        );
    }

    private void on_focused_workspace_changed() {
        var focused = compositor.focused_workspace;
        var child = content_box.get_first_child();

        while (child != null) {
            if (child is WorkspaceButton) {
                var btn = (WorkspaceButton) child;
                if (focused != null && btn.workspace.id == focused.id) {
                    btn.add_css_class("active");
                } else {
                    btn.remove_css_class("active");
                }
            }
            child = child.get_next_sibling();
        }
    }
}

[GtkTemplate(ui="/bar/workspaces/WorkspaceButton.ui")]
class WorkspaceButton : Gtk.Button {
    public AstalHyprland.Workspace workspace { get; construct; }

    [GtkChild] public unowned Label workspace_id;
    [GtkChild] public unowned Gtk.FlowBox windows_box;

    private AstalHyprland.Hyprland compositor;
    private GLib.ListStore clients;

    public WorkspaceButton(AstalHyprland.Workspace workspace) {
        Object(workspace: workspace);
    }

    construct {
        ////////////////////////////////////
        // UI INIT
        ////////////////////////////////////
        this.clients = new GLib.ListStore(typeof (HyprClient));
        this.compositor = AstalHyprland.get_default();
        this.windows_box.bind_model(
            clients,
            (x) => { return new AppButton((HyprClient) x); }
        );
        this.windows_box.set_layout_manager(new Gtk.BoxLayout(Gtk.Orientation.HORIZONTAL));

        workspace_id.label = workspace.id.to_string();

        ////////////////////////////////////
        // STATE INIT
        ////////////////////////////////////
        foreach (var client in compositor.clients) {
            if (client.workspace.id == this.workspace.id) {
                this.clients.append(new HyprClient(client));
            }
        }
        update();

        ////////////////////////////////////
        // SIGNALS WIRING
        ////////////////////////////////////
        clicked.connect(() => { workspace.focus(); });

        compositor.client_added.connect((t, cl)=>{
            if (cl.workspace.id == this.workspace.id && cl.address != null){
                this.clients.append(new HyprClient((AstalHyprland.Client) cl));
                update();
            }
        });

        compositor.client_removed.connect((t, a)=>{
            uint pos = 0;
            var target = new HyprClient.only_addr(a);
            if (this.find_client(target, out pos)) {
                this.clients.remove(pos);
                update();
            }
        });

        compositor.client_moved.connect((t, cl, ws) => {
            if (cl.address == null) { return; }

            if (ws.id == this.workspace.id){
                this.clients.append(new HyprClient((AstalHyprland.Client) cl));
                update();
                return; //Should not process other branch
            }

            // Remove from this workspace if the client is gone
            uint pos = 0;
            var target = new HyprClient.only_addr(cl.address);
            if (find_client(target, out pos)) {
                this.clients.remove(pos);
                update();
                return;
            }
        });
    }

    private void update() {
        windows_box.visible = clients.n_items > 0;
    }

    private bool find_client(HyprClient target, out uint idx) {
        return this.clients.find_with_equal_func(
            target,
            (a, b) =>{ return ((HyprClient) a).address == ((HyprClient) b).address; },
            out idx
        );
    }
}

[GtkTemplate (ui = "/bar/workspaces/AppButton.ui")]
class AppButton : Gtk.Button {
    public HyprClient client { get; construct; }

    [GtkChild] public unowned Image app_icon;

    [GtkChild] public unowned Gtk.Box indicator;

    private AstalApps.Apps appManager;
    private AstalHyprland.Hyprland compositor;

    public AppButton(HyprClient client) {
        Object(client: client);
    }

    construct {
        this.compositor = AstalHyprland.get_default();
        appManager = new AstalApps.Apps();

        app_icon.icon_name = get_icon_name();

        clicked.connect(() => {
            compositor.dispatch("focus", @"{window=\"address:0x$(this.client.address)\"}");
        });

        var right_click = new GestureClick();
        right_click.button = Gdk.BUTTON_SECONDARY;
        right_click.pressed.connect(() => {
            compositor.dispatch("window.close", @"\"address:0x$(this.client.address)\"");
        });
        add_controller(right_click);
    }

    private new string get_icon_name() {
        var app_info = appManager.exact_query(this.client.class);
        if (app_info != null) {
            return app_info.first()
                    ?.data
                    ?.icon_name
                    ?? "application-x-executable";
        }

        return "application-x-executable";
    }
}
