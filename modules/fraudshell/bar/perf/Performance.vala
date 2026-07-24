[GtkTemplate(ui="/bar/perf/PerformanceWidget.ui")]
class PerformanceWidget: Gtk.Box {

    [GtkChild] unowned Gtk.Label cpu_percent;
    [GtkChild] unowned Gtk.Label ram_percent;

    public PerformanceWidget {
        Object();
    }
    construct {

    }

}
