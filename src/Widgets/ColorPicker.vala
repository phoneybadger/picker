/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class ColorPicker : OverlayWindow {
        private enum Cursor {
            DEFAULT,
            PICKER
        }

        public signal void cancelled ();
        public signal void picked (Picker.Color color);

        construct {
            sync_with_controller ();
        }

        private void sync_with_controller () {
            var color_controller = ColorController.get_instance ();

            button_release_event.connect (on_mouse_clicked);

            cursor_moved.connect ((x, y) => {
                color_controller.preview_color = get_color_at (x, y);
            });

            key_release_event.connect ((event) => {
                on_key_pressed (event);
                return true;
            });

            cancelled.connect (() => {
                debug ("Pick cancelled");
                stop_picking ();
                color_controller.preview_color = color_controller.last_picked_color;
            });

            picked.connect ((picked_color) => {
                stop_picking ();
                color_controller.last_picked_color = picked_color;
                color_controller.color_history.append (picked_color);
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
            /* Pick color on left click and cancel pick on right click */
            if (event.button == 1) {
                var color = get_color_at ((int) event.x, (int) event.y);
                debug ("picked color %s", color.to_hex_string ());
                picked (color);
            } else if (event.button == 3) {
                cancelled ();
            }
            return true;
        }

        private void on_key_pressed (Gdk.EventKey event) {
            if (event.keyval == Gdk.Key.Escape) {
                cancelled ();
            }
        }

        private void stop_picking () {
            set_cursor (Cursor.DEFAULT);
            hide ();
        }

        public void start_picking () {
            set_cursor (Cursor.PICKER);
            show ();
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
