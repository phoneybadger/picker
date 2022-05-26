namespace Picker {
    public class ColorController : Object {
        public Picker.Color active_color {get; set;}
        public Picker.Color picked_color {get; set;}
        public Picker.ColorHistory color_history {get; set;}

        private const int HISTORY_SIZE = 5;

        construct {
            color_history = new ColorHistory (HISTORY_SIZE);

            notify ["picked-color"].connect (() => {
                active_color = picked_color;
            });
        }

        public void load_history_from_config (GLib.Settings settings) {
            var color_history_hex_codes = settings.get_strv ("color-history");
            foreach (var hex_code in color_history_hex_codes) {
                var color = new Color ();
                color.parse (hex_code);
                color_history.append (color);
            }
            picked_color = color_history[color_history.size - 1];
        }

        public void save_history_to_config (GLib.Settings settings) {
            var hex_codes = new string[color_history.size];
            for (int i = 0; i < color_history.size; i++) {
                hex_codes[i] = color_history[i].to_hex_string ();
            }
            settings.set_strv ("color-history", hex_codes);
        }
    }
}
