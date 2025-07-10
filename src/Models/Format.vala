/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Cherrypick {
    public enum Format {
        HEX,
        RGB,
        RGBA,
        CMYK,
        HSL;

        public string to_string () {
            switch (this) {
                case HEX:
                    return "HEX";
                case RGB:
                    return "RGB";
                case RGBA:
                    return "RGBA";
                case CMYK:
                    return "CMYK";
                case HSL:
                    return "HSL";
                default:
                    assert_not_reached ();
            }
        }

        public static Format[] all () {
            return {HEX, RGB, RGBA, CMYK, HSL};
        }
    }
}
