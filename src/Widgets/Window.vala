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

            var color_controller = new ColorController ();
            var color_picker = new ColorPicker ();

            color_controller.bind_property (
                "active-color",
                color_area,
                "color",
                BindingFlags.DEFAULT
            );

            color_picker.bind_property (
                "color",
                color_controller,
                "active-color",
                BindingFlags.DEFAULT
            );

            color_picker.cancelled.connect (() => {
                color_controller.active_color = color_controller.picked_color;
            });

            color_picker.picked.connect ((color) => {
                color_controller.picked_color = color;
            });


            color_controller.notify ["active-color"].connect (() => {
                color_label.set_text (color_controller.active_color.to_hex_string ());
            });

            pick_button.clicked.connect (() => {
                color_picker.show ();
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
