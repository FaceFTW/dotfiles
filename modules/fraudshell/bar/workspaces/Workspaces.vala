using Gtk;
using Gdk;
using Astal;
using AstalHyprland;

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
public class WorkspaceButton : Gtk.Button {
    public AstalHyprland.Workspace workspace { get; construct; }
    [GtkChild]
    public unowned Label workspace_id;
    [GtkChild]
    public unowned Gtk.Box windows_box;

    private AstalHyprland.Hyprland compositor;
    // private List<weak AppButton> app_buttons; // Can't access these once they are in Gtk.Box easily

    public WorkspaceButton(AstalHyprland.Workspace workspace) {
        Object(workspace: workspace);
    }

    construct {
        this.compositor = AstalHyprland.get_default();

        workspace_id.label = workspace.id.to_string();

        clicked.connect(() => {
            workspace.focus();
        });

        //TODO Not a fan of the looping but seems to be a vala limitation
        // and my inner FP talking
        foreach (var client in compositor.clients) {
            if (client.workspace.id == workspace.id) {
                var btn = new AppButton(client);
                windows_box.append(btn);
            }
        }

        if (windows_box..length() > 0) {
            windows_box.visible = true;
        }

        compositor.client_added.connect((t,a)=>{
            var btn = new AppButton(a);
            windows_box.append(btn);
        });


    }

}

[GtkTemplate (ui = "/bar/workspaces/AppButton.ui")]
public class AppButton : Gtk.Button {
    public string window_class { get; construct; }
    public string address { get; construct; }

    [GtkChild]
    public unowned Image app_icon;

    [GtkChild]
    public unowned Gtk.Box indicator;

    private AstalApps.Apps appManager;
    private AstalHyprland.Hyprland compositor;

    public AppButton(AstalHyprland.Client window) {
        Object(
            window_class: window.class,
            address: window.address
        );
    }

    construct {
        this.compositor = AstalHyprland.get_default();
        appManager = new AstalApps.Apps();

        app_icon.icon_name = get_icon_name();

        clicked.connect(() => {

            compositor.dispatch("focus", @"{window=\"address:0x$(this.address)\"}");
        });

        var right_click = new GestureClick();
        right_click.button = Gdk.BUTTON_SECONDARY;
        right_click.pressed.connect(() => {
        	compositor.dispatch("window.close", @"\"address:0x$(this.address)\"");
        });
        add_controller(right_click);


        compositor.client_removed.connect((t,a)=>{
            if (this.address == a) {
                this.destroy();
            }
        });
    }

    private new string get_icon_name() {

        var app_info = appManager.exact_query(this.window_class).first().data;
        if (app_info != null) {
            return app_info.icon_name;
        }

        return "application-x-executable";
    }
}
