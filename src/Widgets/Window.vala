/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class Window : Hdy.ApplicationWindow {
        private Gtk.Button pick_button;
        private FormatArea format_area;

        public Window (Gtk.Application app) {
            Object (
                application: app
            );
        }

        construct {
            create_layout ();
            load_css ();
            load_state_from_gsettings ();

            var color_picker = new ColorPicker ();

            pick_button.clicked.connect (() => {
                color_picker.show ();
            });

            delete_event.connect (() => {
                save_state_to_gsettings ();
            });
        }

        private void create_layout () {
            Hdy.init ();
            var window_grid = new Gtk.Grid ();
            default_width = 480;
            default_height = 240;
            resizable = false;

            var headerbar = new Hdy.HeaderBar () {
                show_close_button = true,
                title = _("Picker")
            };

            var header_style = headerbar.get_style_context ();
            header_style.add_class (Gtk.STYLE_CLASS_FLAT);

            var window_handle = new Hdy.WindowHandle ();
            window_handle.add (window_grid);

            var color_preview = new Picker.ColorPreview ();

            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 10) {
                vexpand = true,
                valign = Gtk.Align.START,
                margin = 10,
            };

            pick_button = new Gtk.Button.with_label (_("Pick Color"));
            pick_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

            var format_label = new Gtk.Label (_("Format"));
            format_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            format_label.xalign = 0;

            format_area = new Picker.FormatArea ();

            var history_label = new Gtk.Label (_("History"));
            history_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            history_label.xalign = 0;

            var history_buttons = new HistoryButtons ();

            vbox.add (format_label);
            vbox.add (format_area);
            vbox.add (history_label);
            vbox.add (history_buttons);
            vbox.add (pick_button);

            var toast_overlay = ToastOverlay.get_instance ();
            toast_overlay.add (vbox);

            window_grid.attach (headerbar, 0, 0);
            window_grid.attach (toast_overlay, 0, 1);
            window_grid.attach (color_preview, 1, 0, 1, 2);
            add (window_handle);
        }

        private void load_state_from_gsettings () {
            var settings = Settings.get_instance ();
            int pos_x, pos_y;
            settings.get ("position", "(ii)", out pos_x, out pos_y);
            move (pos_x, pos_y);
        }

        private void save_state_to_gsettings () {
            var settings = Settings.get_instance ();
            int pos_x, pos_y;
            get_position (out pos_x, out pos_y);
            settings.set ("position", "(ii)", pos_x, pos_y);
        }

        private void load_css () {
            var css_provider = new Gtk.CssProvider ();
            css_provider.load_from_resource ("/com/github/phoneybadger/picker/application.css");

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
    }
}
