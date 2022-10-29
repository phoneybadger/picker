/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class ColorPreview : Gtk.Box {
        private string color_definition = "@define-color preview_color %s;";
        private Gtk.CssProvider css_provider;

        public ColorPreview () {
            Object (
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 0,
                hexpand: true,
                vexpand: true
            );
        }

        construct {
            width_request = 220;
            create_style ();
            sync_color_with_controller ();
        }

        private void create_style () {
            var style = get_style_context ();
            style.add_class ("color-preview");

            css_provider = new Gtk.CssProvider ();

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        private void sync_color_with_controller () {
            var color_controller = ColorController.get_instance ();

            realize.connect (() => {
                set_color (color_controller.preview_color);
            });

            color_controller.notify ["preview-color"].connect (() => {
                set_color (color_controller.preview_color);
            });
        }

        private void set_color (Color color) {
            var color_css = color_definition.printf (color.to_hex_string ());
            css_provider.load_from_data (color_css.data);

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
    }
}
