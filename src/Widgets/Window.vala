namespace Picker {
    public class Window : Gtk.ApplicationWindow {
        public Window (Gtk.Application app) {
            Object (
                application: app
            );
        }

        construct {
            default_width = 200;
            default_height = 200;
            title = "Picker";
        }
    }
}
