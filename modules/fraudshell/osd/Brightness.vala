class Brightness: Object {
    private static Brightness instance;
    public static Brightness get_default(){
        if (instance == null ){
            instance = new Brightness();
        }
        return instance;
    }

    private float _screen;
    public float screen {
        get { return _screen; }
        set {
            if (!this.available) { return; }
            if ( value < 0 ) { value = 0; }
            if ( value > 1) { value = 1; }

            this._screen = value;
            this.notify_property("screen");

            foreach (var monitor in this.monitors){
                if (monitor.changing) {
                    monitor.pending_percent = value;
                } else {
                    //this.set_monitor_brightness(monitor, value);
                }
            }
        }
    }
    public bool available { get; private set; }
    public List<MonitorState> monitors { get; construct; }

    public Brightness(){
        Object();
    }

    construct {

    }

    static construct {

    }

}

class MonitorState {
    public string id { get; set; }
    public string type { get; set; }
    public string? bus { get; set; }
    public bool changing { get; set; }
    public float? pending_percent { get; set; }
}
