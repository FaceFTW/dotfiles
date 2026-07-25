using GTop;

[GtkTemplate(ui="/bar/perf/PerformanceWidget.ui")]
class PerformanceWidget: Gtk.Box {

    public double cpu_usage { get; set; }
    public uint64 memory_used  { get; set; }
    public uint64 memory_total { get; set; }
    public uint64 memory_usage { get; set; }

    [GtkChild] unowned Gtk.Label cpu_percent;
    [GtkChild] unowned Gtk.Label ram_percent;

    private uint interval = 0;
    private uint64 last_cpu_total = 0;
    private uint64 last_cpu_used = 0;

    public PerformanceWidget() { Object(); }
    construct {
        GTop.init();

        if (this.interval == 0){
            this.interval = Timeout.add(2000, () => {
                this.update();
                return Source.CONTINUE;
            });
        }

        this.bind_property(
            "cpu_usage",
            this.cpu_percent, "label",
            BindingFlags.SYNC_CREATE,
            (_, src, ref target) => { target.set_string("%3.f%%".printf((double) src * 100)); return true; }
        );
    }

    void update() {
        if (this.cpu_usage != -1.0){ this.updateCpuUsage(); }
    }

    private async void updateCpuUsage(){
        // try {
            GTop.Cpu cpu = new GTop.Cpu();

            var total = cpu.total;
            var idle = cpu.idle;
            var used = total - idle;

            if (this.last_cpu_total > 0){
                var total_diff = total - this.last_cpu_total;
                var used_diff = used - this.last_cpu_used;

                if (total_diff > 0) {
                    this.cpu_usage = (double) used_diff / (double) total_diff;
                }
            }

            this.last_cpu_total = total;
            this.last_cpu_used = used;
            info(this.cpu_usage.to_string());
        // } catch (var _) {
        //     if (this.cpu_usage != -1.0) {
        //         warning ("CPU Monitoring Unavailable (GTop Failure)");
        //         this.cpu_usage = -1.0;
        //     }
        // }
    }

}
