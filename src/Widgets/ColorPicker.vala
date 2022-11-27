/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class ColorPicker : Object {
        private Xdp.Portal portal;
        private ColorController color_controller;

        construct {
            color_controller = ColorController.get_instance ();
        }

        public async void pick () {
            portal = new Xdp.Portal ();
            portal.pick_color.begin (null, null, color_picked);
        }

        private void color_picked (Object? obj, AsyncResult result) {
            try {
                var color = portal.pick_color.end (result);
                double r, g, b;

                VariantIter iter = color.iterator ();
                iter.next ("d", out r);
                iter.next ("d", out g);
                iter.next ("d", out b);

                var picked_color = new Color () {
                    red = (uint8) (r * 255),
                    green = (uint8) (g * 255),
                    blue = (uint8) (b * 255),
                };
                color_controller.last_picked_color = picked_color;
                color_controller.color_history.append (picked_color);
            } catch (Error e) {
                critical (e.message);
            }
        }
    }
}
