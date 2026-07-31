[GtkTemplate(ui="/bar/perf/PerformanceWidget.ui")]
class PerformanceWidget: Gtk.Box {

    public double cpu_usage { get; set; }
    public double mem_usage { get; set; }

    [GtkChild] unowned Gtk.Label cpu_percent;
    [GtkChild] unowned Gtk.Label ram_percent;

    private uint interval = 0;
    private uint64 last_cpu_total = 0;
    private uint64 last_cpu_used = 0;
    private DataInputStream proc_stat_stream;
    private DataInputStream proc_meminfo_stream;

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

        try {
            var proc_meminfo = File.new_for_path("/proc/meminfo");
            var proc_meminfo_inner = proc_meminfo.read();
            this.proc_meminfo_stream = new DataInputStream(proc_meminfo_inner);
        } catch (IOError _) {
            if (this.mem_usage != -1.0) {
                warning (@"Mem Monitoring Unavailable (Issue with opening stream to /proc/meminfo)");
                this.mem_usage = -1.0;
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
            (_, src, ref target) => {
                target.set_string("%3.f%%".printf((double) src * 100));
                this.cpu_percent.queue_resize();
                return true;
            }
        );

        this.bind_property(
            "mem_usage",
            this.ram_percent, "label",
            BindingFlags.SYNC_CREATE,
            (_, src, ref target) => {
                target.set_string("%3.f%%".printf((double) src * 100));
                this.ram_percent.queue_resize();
                return true;
            }
        );
    }

    void update() {
        if (this.cpu_usage != -1.0){ this.updateCpuUsage(); }
        if (this.mem_usage != -1.0){ this.updateMemUsage(); }
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
        } catch (IOError _) {
            if (this.cpu_usage != -1.0) {
                warning (@"CPU Monitoring Failed, disabling");
                this.cpu_usage = -1.0;
            }
        }
    }

    private async void updateMemUsage(){
        try {
            this.proc_meminfo_stream.seek(0, SeekType.SET);

            uint? total = null;
            uint? available = null;

            var line = this.proc_meminfo_stream.read_line();
            while (line != null) {
                if (total != null && available != null) { break; }

                var data = line.split(":");
                var value = uint.parse(data[1].strip().slice(0,-3));

                if (data[0] == "MemTotal") {
                    total = value;
                } else if (data[0] == "MemAvailable"){
                    available = value;
                }

                line = this.proc_meminfo_stream.read_line();
            }

            if (total == null || available == null){
                warning (@"Mem Monitoring failure (Missing MemTotal or MemAvailable), disabling");
                this.mem_usage = -1.0;
                return;
            }

            this.mem_usage = (double)(total - available) / (double) total;

        } catch (IOError _) {
            warning (@"Mem Monitoring failure, disabling");
            this.mem_usage = -1.0;
        }
    }
}
