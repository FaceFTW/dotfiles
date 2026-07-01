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
    [GtkChild]
    public unowned Gtk.Box content_box;

    private AstalHyprland.Hyprland compositor;

    public WorkspacesWidget() {
        Object();
    }

    construct {
        this.compositor = AstalHyprland.get_default();


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
    [GtkChild]
    public unowned Label workspace_id;
    [GtkChild]
    public unowned Gtk.FlowBox windows_box;

    private AstalHyprland.Hyprland compositor;
    private GLib.ListStore clients; // Can't access these once they are in Gtk.Box easily

    public WorkspaceButton(AstalHyprland.Workspace workspace) {
        Object(workspace: workspace);
    }

    construct {
    	this.clients = new GLib.ListStore(typeof (HyprClient));
     	this.compositor = AstalHyprland.get_default();
        this.windows_box.bind_model(
            clients,
            (x) => { return new AppButton((HyprClient) x); }
        );

        workspace_id.label = workspace.id.to_string();

        clicked.connect(() => {
            workspace.focus();
        });

        foreach (var client in compositor.clients) {
            if (client.workspace.id == this.workspace.id) {
            	this.clients.append(new HyprClient(client));
            }
        }

        if (clients.n_items > 0) {
            windows_box.visible = true;
        }

        compositor.client_added.connect((t,a)=>{
        	if (a.workspace.id == this.workspace.id){
        		this.clients.append(new HyprClient((AstalHyprland.Client) a));
          	}
        });

        compositor.client_removed.connect((t,a)=>{
        	uint pos = 0;

         	var target = new HyprClient.only_addr(a);
         	if (this.clients.find_with_equal_func(
          		target,
            	(a,b) =>{return ((HyprClient) a).address == ((HyprClient) b).address;},
             	out pos)) {
        	this.clients.remove(pos);
         }
        });


    }

}

[GtkTemplate (ui = "/bar/workspaces/AppButton.ui")]
class AppButton : Gtk.Button {
	public HyprClient client { get; construct; }

    [GtkChild]
    public unowned Image app_icon;

    [GtkChild]
    public unowned Gtk.Box indicator;

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

        var app_info = appManager.exact_query(this.client.class).first().data;
        if (app_info != null) {
            return app_info.icon_name;
        }

        return "application-x-executable";
    }
}
