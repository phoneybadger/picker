namespace Picker {
    public class Color : Object {
        public uint8 red {get; set;}
        public uint8 green {get; set;}
        public uint8 blue {get; set;}
        public double alpha {get; set;}

        public string to_hex_string () {
            var hex_string = "#%02x%02x%02x".printf (red, green, blue).up ();

            return hex_string;
        }

        public string to_rgba_string () {
            var rgba_string = "rgba(%d, %d, %d, 1)".printf (red, green, blue);

            return rgba_string;
        }

        public string to_rgb_string () {
            var rgb_string = "rgb(%d, %d, %d)".printf (red, green, blue);

            return rgb_string;
        }
    }
}
