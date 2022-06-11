/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public enum Format {
        HEX,
        RGB,
        RGBA;

        public string to_string () {
            switch (this) {
                case HEX:
                    return "HEX";
                case RGB:
                    return "RGB";
                case RGBA:
                    return "RGBA";
                default:
                    assert_not_reached ();
            }
        }

        public static Format[] all () {
            return {HEX, RGB, RGBA};
        }
    }
}
