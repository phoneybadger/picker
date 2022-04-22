namespace Picker {
    public class Window : Gtk.ApplicationWindow {
        public Window (Gtk.Application app) {
            Object (
                application: app
            );
        }

        construct {
            default_width = 400;
            default_height = 200;
            resizable = false;

            var headerbar = new Gtk.HeaderBar () {
                show_close_button = true,
                title = "Picker"
            };

            var header_style = headerbar.get_style_context ();
            header_style.add_class (Gtk.STYLE_CLASS_FLAT);
            set_titlebar (headerbar);

            var button = new Picker.ColorArea ();

            var layout_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin = 10,
                halign = Gtk.Align.START
            };

            layout_box.pack_start (button, false, true, 0);

            add (layout_box);
        }
    }
}
