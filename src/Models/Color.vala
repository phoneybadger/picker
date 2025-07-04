/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
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
