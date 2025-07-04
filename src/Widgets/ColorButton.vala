/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    class ColorButton: Gtk.Button {
        public Color color {get; set construct;}
        private Gtk.ColorButton color_button;

        public ColorButton (Color color) {
            Object (
                color: color
            );
        }

        construct {

            create_layout ();

            var color_controller = ColorController.get_instance ();

            notify ["color"].connect (() => {
                if (color != null) {
                    color_button.rgba = color.to_rgba ();
                }
            });

            clicked.connect (() => {
                color_controller.preview_color = color;
            });
        }

        private void create_layout () {
            /* Wrapping a Gtk.ColorButton to actually display the color. Wrapping
               inside this button instead of directly using Gtk.ColorButton to
               override the color selection dialogue functionality that comes
               with the Gtk.ColorButton, and also we need to use the 'clicked'
               signal that comes with Gtk.Button which is not available with
               Gtk.ColorButton. Not using a Gtk.Button with custom styles for
               background color for better compatibility. Custom stylesheet could
               be broken when using on some distros and their stylesheets, but
               Gtk.ColorButton being a native Gtk widget should get rendered
               properly */
            get_style_context ().add_class ("color-button");

            color_button = new Gtk.ColorButton.with_rgba (color.to_rgba ()) {
                hexpand = true
            };
            child = color_button;
        }
    }
}
