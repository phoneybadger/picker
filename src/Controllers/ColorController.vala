namespace Picker {
    public class ColorController : Object {
        public Picker.Color active_color {get; set;}
        public Picker.Color picked_color {get; set;}


        construct {
            notify ["picked-color"].connect (() => {
                active_color = picked_color;
            });
        }

        public void load_color_from_config (GLib.Settings settings) {
            int red, green, blue;
            settings.get ("color", "(iii)", out red, out green, out blue);
            var saved_color = Gdk.RGBA ();
            saved_color.red = red / 255.0;
            saved_color.green = green / 255.0;
            saved_color.blue = blue / 255.0;
            saved_color.alpha = 1;

            picked_color = saved_color;
        }

        public void save_color_to_config (GLib.Settings settings) {
            var red = (uint8) (picked_color.red * 255);
            var green = (uint8) (picked_color.green * 255);
            var blue = (uint8) (picked_color.blue * 255);

            settings.set ("color", "(iii)", red, green, blue);
        }
    }
}
