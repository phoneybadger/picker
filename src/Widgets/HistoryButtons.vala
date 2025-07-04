/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    class HistoryButtons: Gtk.Box {
        private Gee.ArrayList<ColorButton> color_buttons;
        private ColorController color_controller;

        public HistoryButtons () {
            Object (
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 6
            );
        }

        construct {
            color_controller = ColorController.get_instance ();
            color_buttons = new Gee.ArrayList<ColorButton> ();

            color_controller.color_history.changed.connect (() => {
                update_buttons ();
            });

            for (var i = 0; i < color_controller.color_history.size; i++) {
                var button_name = "color-button-%d".printf (i);
                var color = color_controller.color_history[i];
                var color_button = new ColorButton (color, button_name) {
                    width_request = 45,
                    height_request = 30
                };
                color_buttons.add (color_button);
                append (color_button);
            }
        }

        private void update_buttons () {
            for (var i = 0; i < color_buttons.size; i++) {
                var button = color_buttons[i];
                button.color = color_controller.color_history[i];
            }
        }
    }
}
