namespace Picker {
    public class Application : Gtk.Application {
        public Application () {
            Object (
                application_id: "com.github.phoneybadger.picker",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        public override void activate () {
            var window = new Picker.Window (this);
            window.show_all ();
        }
    }
}
