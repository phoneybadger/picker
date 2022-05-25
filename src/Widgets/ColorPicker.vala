namespace Picker {
    public class ColorPicker : OverlayWindow {
        private enum Cursor {
            DEFAULT,
            PICKER
        }

        public Picker.Color color {get; set;}

        public signal void cancelled ();
        public signal void picked (Picker.Color color);

        construct {
            show.connect (() => {
                set_cursor (Cursor.PICKER);
            });
            button_release_event.connect (on_mouse_clicked);
            cursor_moved.connect ((x, y) => {
                color = get_color_at (x, y);
            });
        }

        private Picker.Color get_color_at (int x, int y) {
            var root_window = Gdk.get_default_root_window ();
            var pixbuf = Gdk.pixbuf_get_from_window (root_window, x, y, 1, 1);

            var color = new Color () {
                red = pixbuf.get_pixels ()[0],
                green = pixbuf.get_pixels ()[1],
                blue = pixbuf.get_pixels ()[2],
                alpha = 1
            };
            return color;
        }

        private bool on_mouse_clicked (Gdk.EventButton event) {
            if (event.button == 1) {
                debug ("picked color %s", color.to_hex_string ());
                picked (color);
                stop_picking ();
            } else if (event.button == 3) {
                cancelled ();
                stop_picking ();
            }
            return true;
        }

        private void stop_picking () {
            debug ("Aborted picking");
            set_cursor (Cursor.DEFAULT);
            hide ();
        }

        private void set_cursor (Cursor cursor) {
            var window = Gdk.get_default_root_window ();
            var display = window.get_display ();
            var default_cursor = new Gdk.Cursor.from_name (display, "default");
            var picker_cursor = new Gdk.Cursor.from_name (display, "crosshair");

            if (cursor == Cursor.DEFAULT) {
                window.cursor = default_cursor;
            } else if (cursor == Cursor.PICKER) {
                window.cursor = picker_cursor;
            }
        }
    }
}
