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
            picked_color = new Color () {
                red = (uint8) red,
                green = (uint8) green,
                blue = (uint8) blue,
                alpha = 1
            };
        }

        public void save_color_to_config (GLib.Settings settings) {
            var red = picked_color.red;
            var green = picked_color.green;
            var blue = picked_color.blue;

            settings.set ("color", "(iii)", red, green, blue);
        }
    }
}
