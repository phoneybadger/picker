namespace Picker {
    public class Window : Gtk.ApplicationWindow {
        private GLib.Settings settings;
        private Gtk.Button pick_button;
        private Picker.ColorArea color_area;
        private Gtk.Label color_label;
        private Picker.FormatArea format_area;
        private Picker.ColorController color_controller;

        public Window (Gtk.Application app) {
            Object (
                application: app
            );
        }

        construct {
            create_layout ();

            color_controller = new ColorController ();


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

            color_controller.bind_property (
                "active-color",
                format_area,
                "color",
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

            delete_event.connect (() => {
                save_config_to_schema ();
            });

            load_config_from_schema ();
        }

        private void create_layout () {
            default_width = 440;
            default_height = 240;
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

            format_area = new Picker.FormatArea ();
            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin = 10,
                halign = Gtk.Align.END,
            };
            vbox.pack_start (color_label);
            vbox.pack_start (pick_button, true, false, 0);
            vbox.pack_start (format_area, true, false, 0);

            var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                margin = 10
            };
            hbox.pack_start (color_area, false, false);
            hbox.pack_start (vbox, true, true, 10);

            add (hbox);
        }

        private void load_config_from_schema () {
            settings = new Settings ("com.github.phoneybadger.picker");
            int pos_x, pos_y;
            settings.get ("position", "(ii)", out pos_x, out pos_y);
            move (pos_x, pos_y);

            color_controller.load_color_from_config (settings);
            format_area.load_format_from_config (settings);
        }

        private void save_config_to_schema () {
            int pos_x, pos_y;
            get_position (out pos_x, out pos_y);
            settings.set ("position", "(ii)", pos_x, pos_y);

            color_controller.save_color_to_config (settings);
            format_area.save_format_to_config (settings);
        }
    }
}
