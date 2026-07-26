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
    private DataInputStream proc_stat_stream;

    public PerformanceWidget() { Object(); }
    construct {
        try {
            var proc_stat = File.new_for_path("/proc/stat");
            var proc_stat_inner = proc_stat.read();
            this.proc_stat_stream = new DataInputStream(proc_stat_inner);
        } catch (IOError _) {
            if (this.cpu_usage != -1.0) {
                warning (@"CPU Monitoring Unavailable (Issue with opening stream to /proc/stat)");
                this.cpu_usage = -1.0;
            }
        }

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
        try {
            this.proc_stat_stream.seek(0, SeekType.SET);
            var line = this.proc_stat_stream.read_line();
            var stat_line = line.substring(4);
            var stats = stat_line.split(" ");

            var idle = long.parse(stats[3]) + long.parse(stats[4]); // idle + iowait
            var total = 0l;
            foreach (var stat in stats) { total += long.parse(stat); }
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
        } catch (IOError _) {
            if (this.cpu_usage != -1.0) {
                warning (@"CPU Monitoring Failed, disabling");
                this.cpu_usage = -1.0;
            }
        }
    }

}
