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
public class WorkspaceButton : Button {
    public AstalHyprland.Workspace workspace { get; construct; }
    [GtkChild]
    public unowned Label workspace_id;
    [GtkChild]
    public unowned Gtk.Box windows_box;

    private AstalHyprland.Hyprland compositor;

    public WorkspaceButton(AstalHyprland.Workspace workspace) {
        Object(workspace: workspace);
    }

    construct {
    	this.compositor = AstalHyprland.get_default();

     	workspace_id.label = workspace.id.to_string();
        //TODO Not a fan of the looping but seems to be a vala limitation
        // and my inner FP talking
        var windows = new GLib.List<AstalHyprland.Client>();
        foreach (var client in compositor.clients) {
            if (client.workspace.id == workspace.id) {
                windows.append(client);
            }
        }

        if (windows.length() > 0) {
            windows_box.visible = true;
            foreach (var win in windows) {
                var app_btn = new AppButton(win);
                windows_box.append(app_btn);
            }
        }
        clicked.connect(() => {
            workspace.focus();
        });
    }
}

[GtkTemplate (ui = "/bar/workspaces/AppButton.ui")]
public class AppButton : Button {
    public AstalHyprland.Client window { get; construct; }

    [GtkChild]
    public unowned Image app_icon;

    [GtkChild]
    public unowned Gtk.Box indicator;

    private AstalApps.Apps appManager;

    public AppButton(AstalHyprland.Client window) {
        Object(window: window);

    }

    construct {
    	appManager = new AstalApps.Apps();

        app_icon.icon_name = get_icon_name();

        clicked.connect(() => {
            window.focus();
        });

        var right_click = new GestureClick();
        right_click.button = Gdk.BUTTON_SECONDARY;
        right_click.pressed.connect(() => {
            window.kill();
        });
        add_controller(right_click);
    }

    private new string get_icon_name() {
        string window_class = window.class;

        var app_info = appManager.exact_query(window_class).first().data;
        if (app_info != null) {
            return app_info.icon_name;
        }

        return "application-x-executable";
    }
}
