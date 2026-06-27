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
        this.compositor = AstalHyprland.get_default();
        this.setup();
    }

    private void setup() {
        var workspaces = compositor.workspaces;

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
    public unowned Label window_count;
    [GtkChild]
    public unowned Gtk.Box windows_box;
    private AstalHyprland.Hyprland compositor;
    public WorkspaceButton(AstalHyprland.Workspace workspace) {
        Object(workspace: workspace);
        this.compositor = AstalHyprland.get_default();
        this.setup();
    }

    private void setup() {
        workspace_id.label = workspace.id.to_string();
        //TODO Not a fan of the looping but seems to be a vala limitation
        // and my inner FP talking
        var windows = new GLib.List<AstalHyprland.Client>();
        foreach (AstalHyprland.Client client in compositor.clients) {
            if (client.workspace.id == workspace.id) {
                windows.append(client);
            }
        }
        window_count.label = windows.length().to_string();
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
    public unowned Label app_title;

    [GtkChild]
    public unowned Gtk.Box indicator;


    public AppButton(AstalHyprland.Client window) {
        Object(window: window);
        this.setup();
    }

    private void setup() {
        app_title.label = window.title;
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

    private string get_icon_name() {
        // var config_icons = config.bar.modules.workspaces.taskbar_icons;
        // string window_class = window.class;

        // if (window_class in config_icons) {
        //     return config_icons[window_class];
        // }

        // var app_info = AppInfo.get_default_for_type(window_class, false);
        // if (app_info != null) {
        //     return app_info.get_icon().to_string();
        // }

        return "application-x-executable";
    }
}
