namespace Picker {
    public class ColorArea : Gtk.Box {
        private string color_definition = "@define-color area_color %s;";
        private Gtk.CssProvider css_provider;

        public ColorArea () {
            Object (
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 0,
                expand: true
            );
        }

        construct {
            var color_controller = ColorController.get_instance ();

            color_controller.notify ["preview-color"].connect (() => {
                set_color (color_controller.preview_color);
            });

            var style = get_style_context ();
            style.add_class ("color-area");

            css_provider = new Gtk.CssProvider ();

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        private void set_color (Color color) {
            var color_css = color_definition.printf (color.to_hex_string ());
            try {
                css_provider.load_from_data (color_css, color_css.length);

                Gtk.StyleContext.add_provider_for_screen (
                    Gdk.Screen.get_default (),
                    css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );
            } catch (Error e) {
                debug (e.message);
                return;
            }
        }
    }
}
