namespace Picker {
    public class ColorArea : Gtk.Box {
        public Picker.Color color {get; set;}

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

            var css_provider = new Gtk.CssProvider ();
            css_provider.load_from_resource ("/com/github/phoneybadger/picker/application.css");

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
    }
}
