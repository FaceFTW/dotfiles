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
    [GtkChild] public unowned Gtk.FlowBox content_box;

    private AstalHyprland.Hyprland compositor;
    private GLib.ListStore workspaces;

    public WorkspacesWidget() {
        Object();
    }

    construct {
        ////////////////////////////////////
        // UI INIT
        ////////////////////////////////////
        this.compositor = AstalHyprland.get_default();
        this.workspaces = new GLib.ListStore(typeof(AstalHyprland.Workspace));

        this.content_box.set_layout_manager(new Gtk.BoxLayout(Gtk.Orientation.HORIZONTAL));
        this.content_box.bind_model(
            workspaces,
            (x) => { return new WorkspaceButton((AstalHyprland.Workspace) x); }
        );

        ////////////////////////////////////
        // STATE INIT
        ////////////////////////////////////
        var workspaces = compositor.workspaces;
        workspaces.sort((a, b) => {
            return (int) (a.id > b.id) - (int) (a.id < b.id);
        });
        foreach (var ws in workspaces) {
            this.append(new WorkspaceButton(ws));
        }
    }
}

[GtkTemplate(ui="/bar/workspaces/WorkspaceButton.ui")]
class WorkspaceButton : Gtk.Button {
    public AstalHyprland.Workspace workspace { get; construct; }

    [GtkChild] public unowned Label workspace_id;
    [GtkChild] public unowned Gtk.FlowBox windows_box;

    private AstalHyprland.Hyprland compositor;
    private AstalApps.Apps app_manager;
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
        this.app_manager = new AstalApps.Apps();
        this.windows_box.add_css_class(@"workspace-$(this.workspace.id)");
        this.windows_box.set_layout_manager(new Gtk.BoxLayout(Gtk.Orientation.HORIZONTAL));
        this.windows_box.bind_model(
            clients,
            (x) => { return construct_app_button((HyprClient) x); }
        );

        workspace_id.label = workspace.id.to_string();
        this.add_css_class(@"workspace-$(this.workspace.id)");

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

        compositor.focused_workspace.notify.connect((s,p) => {
            var focused = compositor.focused_workspace;
            if (focused != null && this.workspace.id == focused.id) {
                this.add_css_class("active");
            } else {
                this.remove_css_class("active");
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

    private Gtk.Image construct_app_button(HyprClient client){
        Gtk.Image component = new Gtk.Image();
        component.icon_size = Gtk.IconSize.LARGE;

        var app_info = app_manager.exact_query(client.class);
        component.icon_name = app_info != null ?
             app_info.first()?.data?.icon_name ?? "application-x-executable" :
             "application-x-executable";

        return component;
    }
}
