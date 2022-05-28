namespace Picker {
    public class ColorController : Object {
        private static ColorController? instance;

        public Picker.Color preview_color {get; set;}
        public Picker.Color last_picked_color {get; set;}
        public Picker.ColorHistory color_history {get; set;}

        private const int HISTORY_SIZE = 5;

        public static ColorController get_instance () {
            if (instance == null) {
                instance = new ColorController ();
            }
            return instance;
        }

        private ColorController () {}

        construct {
            color_history = new ColorHistory (HISTORY_SIZE);

            notify ["last-picked-color"].connect (() => {
                preview_color = last_picked_color;
            });

            load_history_from_gsettings ();
        }

        public void load_history_from_gsettings () {
            var settings = Settings.get_instance ();
            var color_history_hex_codes = settings.get_strv ("color-history");
            foreach (var hex_code in color_history_hex_codes) {
                var color = new Color ();
                color.parse (hex_code);
                color_history.append (color);
            }
            last_picked_color = color_history[color_history.size - 1];
        }

        public void save_history_to_gsettings () {
            var settings = Settings.get_instance ();
            var hex_codes = new string[color_history.size];
            for (int i = 0; i < color_history.size; i++) {
                hex_codes[i] = color_history[i].to_hex_string ();
            }
            settings.set_strv ("color-history", hex_codes);
        }
    }
}
