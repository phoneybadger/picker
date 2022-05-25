namespace Picker {
    public class ColorArea : Gtk.Box {
        public Picker.Color color {get; set;}
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
            var style = get_style_context ();
            style.add_class ("color-area");

            css_provider = new Gtk.CssProvider ();

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            notify ["color"].connect (() => {
                update_color ();
            });
        }

        public void update_color () {
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
