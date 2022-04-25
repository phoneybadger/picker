namespace Picker {
    public class Window : Gtk.ApplicationWindow {
        private Gtk.Button pick_button;
        private Picker.ColorArea color_area;
        private Gtk.Label color_label;

        public Window (Gtk.Application app) {
            Object (
                application: app
            );
        }

        construct {
            create_layout ();

            pick_button.clicked.connect (() => {
                var color_picker = new Picker.ColorPicker ();
                color_picker.show ();

                color_picker.notify ["color"].connect (() => {
                    color_area.color = color_picker.color;
                    color_area.queue_draw ();
                    color_label.set_text (color_picker.color.to_hex_string ());
                });
            });
        }

        private void create_layout () {
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

            color_area = new Picker.ColorArea ();

            pick_button = new Gtk.Button.with_label ("Pick Color");
            pick_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

            color_label = new Gtk.Label (color_area.color.to_hex_string ());
            color_label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin = 10,
            };
            vbox.pack_start (color_label);
            vbox.pack_start (pick_button, true, false, 0);

            var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                margin = 10
            };
            hbox.pack_start (color_area, false, false);
            hbox.pack_start (vbox, true, true, 10);

            add (hbox);
        }
    }
}
