class App : Gtk.Application {
    // alternative is to rely on GLib.Application.get_default
    static App instance;

    private Bar bar;
    private OSDWindow osd;

    private void init_css() {
        var provider = new Gtk.CssProvider();
        provider.load_from_resource("/style.css");

        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }

    // this is the method that will be invoked on `app.run()`
    // this is where everything should be initialized and instantiated
    public override int command_line(ApplicationCommandLine command_line) {
        var argv = command_line.get_arguments();

        if (command_line.is_remote) {
            command_line.print_literal("FRAUDSHELL is already running. Kill the existing instance if you want to refresh!");
        } else {
            // main instance, initialize stuff here
            init_css();
            add_window((bar = new Bar()));
            add_window((osd = new OSDWindow()));
        }

        return 0;
    }

    private App(bool test) {
        application_id = test ? "dev.faceftw.fraudshell-test" : "dev.faceftw.fraudshell";
        flags = ApplicationFlags.HANDLES_COMMAND_LINE;
    }

    // entry point of our app
    static int main(string[] argv) {
        if (argv[1] == "test") {
            App.instance = new App(true);
            Environment.set_prgname("fraudshell-test");
        } else {
            App.instance = new App(false);
            Environment.set_prgname("fraudshell");
        }

        return App.instance.run(argv);
    }
}
