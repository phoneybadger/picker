/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class Application : Gtk.Application {
        public Application () {
            Object (
                application_id: "com.github.phoneybadger.picker",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        public override void activate () {
            var window = new Picker.Window (this);
            window.show_all ();

            set_prefered_color_scheme ();
        }

        private void set_prefered_color_scheme () {
            var gtk_settings = Gtk.Settings.get_default ();
            var granite_settings = Granite.Settings.get_default ();
            gtk_settings.gtk_application_prefer_dark_theme = is_prefer_dark ();
            granite_settings.notify["prefers-color-scheme"].connect (() => {
                gtk_settings.gtk_application_prefer_dark_theme = is_prefer_dark ();
            });
        }

        private bool is_prefer_dark () {
            var granite_settings = Granite.Settings.get_default ();
            return granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        }
    }
}
