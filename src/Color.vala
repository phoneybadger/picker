namespace Picker {
    public struct Color : Gdk.RGBA {
        /* Extended RGBA struct with added utility functions for printing 
        out colors in different formats */
        public string to_hex_string () {
            var hex_string = "#%02x%02x%02x".printf (
                (uint) (this.red * 255),
                (uint) (this.green * 255),
                (uint) (this.blue * 255)
            ).up ();

            return hex_string;
        }

        public string to_rgba_string () {
            var rgba_string = "rgba(%d, %d, %d, 255)".printf (
                (int) (this.red * 255),
                (int) (this.green * 255),
                (int) (this.blue * 255)
            );

            return rgba_string;
        }

        public string to_rgb_string () {
            var rgb_string = "rgb(%d, %d, %d)".printf (
                (int) (this.red * 255),
                (int) (this.green * 255),
                (int) (this.blue * 255)
            );

            return rgb_string;
        }
    }
}
