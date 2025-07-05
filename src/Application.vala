/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class Application : Gtk.Application {
        private Window? window;
        private Xdp.Portal portal;

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
                application_id: "io.github.ellie_commons.cherrypick",
                flags: ApplicationFlags.HANDLES_COMMAND_LINE
            );
        }

        construct {

            var quit_action = new SimpleAction ("quit", null);
            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Control>q"});
            quit_action.activate.connect (quit);

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

                var provider = new Gtk.CssProvider ();
                provider.load_from_resource ("/io/github/ellie_commons/cherrypick/Application.css");
                Gtk.StyleContext.add_provider_for_display (
                    Gdk.Display.get_default (),
                    provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );

                window.show ();
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
            portal = new Xdp.Portal ();
            portal.pick_color.begin (null, null);
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
