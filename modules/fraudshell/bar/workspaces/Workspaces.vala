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

    public WorkspacesWidget() {
        Object();
    }

    construct {
        ////////////////////////////////////
        // UI INIT
        ////////////////////////////////////
        this.compositor = AstalHyprland.get_default();
        this.content_box.set_layout_manager(new Gtk.BoxLayout(Gtk.Orientation.HORIZONTAL));

        ////////////////////////////////////
        // STATE INIT
        ////////////////////////////////////
        var workspaces = compositor.workspaces;
        workspaces.sort((a, b) => {
            return (int) (a.id > b.id) - (int) (a.id < b.id);
        });
        foreach (var ws in workspaces) {
            content_box.append(new WorkspaceButton(ws));
        }

        ////////////////////////////////////
        // SIGNAL WIRING
        ////////////////////////////////////
        // Listen for workspace changes
        compositor.notify["focused-workspace"].connect((t,a) =>{
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
        });
    }
}

[GtkTemplate(ui="/bar/workspaces/WorkspaceButton.ui")]
class WorkspaceButton : Gtk.Button {
    public AstalHyprland.Workspace workspace { get; construct; }

    [GtkChild] public unowned Label workspace_id;
    [GtkChild] public unowned Gtk.FlowBox windows_box;

    private AstalHyprland.Hyprland compositor;
    private AstalApps.Apps appManager;
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
            (x) => { return construct_app_button((HyprClient) x); }
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

    private Gtk.Image construct_app_button(HyprClient client){
        Gtk.Image component = new Gtk.Image();
        component.icon_size = Gtk.IconSize.LARGE;


        var app_info = appManager.exact_query(client.class);
        component.icon_name = app_info != null ?
             app_info.first()?.data?.icon_name ?? "application-x-executable" :
             "application-x-executable";

        return component;
    }
}
