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

            var color_area = new Picker.ColorArea ();
            var pick_button = new Gtk.Button.with_label ("Pick Color");
            pick_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);


            pick_button.clicked.connect (() => {
                var color_picker = new Picker.ColorPicker ();
                color_picker.show ();

                color_picker.notify ["color"].connect (() => {
                    color_area.color = color_picker.color;
                    color_area.queue_draw ();
                });
            });

            var color_label = new Gtk.Label ("#EEEEEE");
            color_label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin = 10,
                halign = Gtk.Align.CENTER,
                expand = true
            };
            vbox.pack_start (color_label, true, true, 0);
            vbox.pack_start (pick_button, true, false, 0);

            var layout_grid = new Gtk.Grid () {
                margin = 10,
            };
            layout_grid.attach (color_area, 0, 0, 1, 1);
            layout_grid.attach (vbox, 1, 0, 1, 1);

            add (layout_grid);
        }
    }
}
