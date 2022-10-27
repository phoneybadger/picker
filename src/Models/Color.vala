/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class Color : Object {
        public uint8 red {get; set;}
        public uint8 green {get; set;}
        public uint8 blue {get; set;}

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

        public Gdk.RGBA to_rgba () {
            var rgba = Gdk.RGBA ();
            rgba.red = ((float) red) / 255;
            rgba.green = ((float) green)/ 255;
            rgba.blue = ((float) blue) / 255;
            rgba.alpha = 1;
            return rgba;
        }

        public void parse (string color_code) {
            /* Parse a color code to set values. Wraps Gdk.RGBA.parse, so
            supports all formats that supports */
            var rgba = Gdk.RGBA ();
            rgba.parse (color_code);
            red = (uint8) (255 * rgba.red);
            green = (uint8) (255 * rgba.green);
            blue = (uint8) (255 * rgba.blue);
        }
    }
}
