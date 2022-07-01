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

        private const OptionEntry[] CMD_OPTION_ENTRIES = {
            {"pick-color", 'p', OptionFlags.NONE, OptionArg.NONE, null, N_("Pick color"), null}
        };

        public Application () {
            Object (
                application_id: "com.github.phoneybadger.picker",
                flags: ApplicationFlags.HANDLES_COMMAND_LINE
            );
        }

        construct {
            add_main_option_entries (CMD_OPTION_ENTRIES);
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

        public override int command_line (ApplicationCommandLine command) {
            activate ();

            /* Opens and immediately starts picking color if the --pick-color
               flag is passed when launching from the command line. This could
               be helpful for the user to set up keybindings and stuff */
            var options = command.get_options_dict ();
            if (options.contains ("pick-color")) {
                lookup_action (ACTION_START_PICK).activate (null);
            }
            return 0;
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
