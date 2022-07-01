/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class Application : Gtk.Application {
        private Window? window;

        public const string ACTION_PREFIX = "app.";
        public const string ACTION_START_PICK = "action-start-pick";

        private const ActionEntry[] ACTION_ENTRIES = {
            {ACTION_START_PICK, action_start_pick}
        };

        public Application () {
            Object (
                application_id: "com.github.phoneybadger.picker",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        public override void activate () {
            set_prefered_color_scheme ();
            add_action_entries (ACTION_ENTRIES, this);

            /* Restricting to only one open instance of the application window.
               It doesn't make much sense to have multiple instances as there
               are no real valid use cases. And with the current architecture
               the state is global and would be shared between multiple
               instances anyway. */
            if (window == null) {
                window = new Picker.Window (this);
                window.show_all ();
            } else {
                window.present ();
            }
        }

        private void action_start_pick () {
            window.color_picker.start_picking ();
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
