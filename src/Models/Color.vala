/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Cherrypick {
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
        
        /*Convert RGB to CMYK*/ 
        public string to_cmyk_string(){

            // dividing by 255 
            float r = red / 255.0f;
            float g = green / 255.0f;
            float b = blue / 255.0f;
            
             // finding the C M Y K values from the primes and the input
            // indexes: R = 0; G = 1; B = 2
            float k = 1 - Math.fmaxf(Math.fmaxf(r,g),b);
            uint8 cyan = (uint8)Math.roundf( (1 - r - k) / (1 - k)*100 );
			uint8 magenta = (uint8)Math.roundf( (1 - g - k) / (1 - k)*100 );
			uint8 yellow = (uint8)Math.roundf( (1 - b - k) / (1 - k)*100 );
            uint8 key = (uint8)Math.roundf(k*100);

            var cmyk_string = "cmyk(%d, %d, %d, %d)".printf (cyan, magenta, yellow, key);

            return cmyk_string;
        }

        /* https://github.com/ckruse/ColorMate/blob/3fdc1dd76099c8996d7eec4de7a7127235664c2c/src/Window.vala#L197 */
        public string to_hsl_string (Rgb rgb, out Hsl hsl) {
            double r = rgb.r / 255.0;
            double g = rgb.g / 255.0;
            double b = rgb.b / 255.0;

            // Find greatest and smallest channel values
            var cmin = double.min (double.min (r, g), b);
            var cmax = double.max (double.max(r, g), b);
            var delta = cmax - cmin;
            double h = 0, s = 0, l = 0;

            // Calculate hue
            if (delta == 0) {
                h = 0;
            }
            else if (cmax == r) {
                h = ((g - b) / delta) % 6;
            }
            else if (cmax == g) {
                h = (b - r) / delta + 2;
            }
            else {
                h = (r - g) / delta + 4;
            }

            h = Math.round (h * 60);

            if (h < 0) {
                h += 360;
            }

            // Calculate lightness
            l = (cmax + cmin) / 2;

            // Calculate saturation
            s = delta == 0 ? 0 : delta / (1 - (2 * l - 1).abs());

            // Multiply l and s by 100
            s = (s * 100.0).abs();
            l = (l * 100.0).abs();

            var hsl_string = "hsl(%d, %d, %d)".printf ((int)h, s, l);

            return hsl_string;

            }


        public void parse (string color_code) {
            /* Parse a color code to set values. Wraps Gdk.RGBA.parse, so
            supports all formats that supports */
            var rgba = Gdk.RGBA ();
            rgba.parse (color_code);
            red = (uint8) (255 * rgba.red);
            green = (uint8) (255 * rgba.green);
            blue = (uint8) (255 * rgba.blue);
            alpha = 1;
        }
    }
}
