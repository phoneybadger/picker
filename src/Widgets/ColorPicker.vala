namespace Picker {
    public class ColorPicker : OverlayWindow {
        private enum Cursor {
            DEFAULT,
            PICKER
        }

        construct {
            set_cursor (Cursor.PICKER);
            button_release_event.connect (on_mouse_clicked);
            cursor_moved.connect ((x, y) => {
                print ("%f, %f\n", x, y);
            });
        }

        private bool on_mouse_clicked (Gdk.EventButton event) {
            if (event.button == 1) {
                print ("pick color");
            } else if (event.button == 3) {
                stop_picking ();
            }
            return true;
        }

        private void stop_picking () {
            debug ("Aborted picking");
            set_cursor (Cursor.DEFAULT);
            destroy ();
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
