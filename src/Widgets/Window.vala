/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class Window : Gtk.Window {
        private Gtk.Button pick_button;
        private Granite.Toast toast;

        public Window (Gtk.Application app) {
            Object (
                application: app,
                title: _("Picker"),
                default_width: 480,
                default_height: 240,
                resizable: false
            );
        }

        construct {

            // We need to hide the title area for the split headerbar
            var null_title = new Gtk.Grid () {
                visible = false
            };
            set_titlebar (null_title);

            toast = new Granite.Toast ("");
            toast.hide ();

            var titlelabel = new Gtk.Label (_("Picker"));
            titlelabel.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

            var headerbar = new Gtk.HeaderBar () {
                title_widget = titlelabel
            };
            headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
            //headerbar.pack_start (new Gtk.WindowControls (Gtk.PackType.START));

            var color_preview = new Picker.ColorPreview ();


            var format_label = new Gtk.Label (_("Format")) {
                xalign = 0f,
                margin_top = 6
            };
            format_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

            var format_area = new Picker.FormatArea ();

            var history_label = new Gtk.Label (_("History")) {
                xalign = 0f,
                margin_top = 6
            };
            history_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

            var history_buttons = new HistoryButtons ();

            pick_button = new Gtk.Button.with_label (_("Pick Color")) {
                margin_top = 6
            };
            pick_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);


            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 10) {
                vexpand = true,
                valign = Gtk.Align.START,
                margin_top = margin_bottom = margin_end = margin_start = 10,
            };
            vbox.append (format_label);
            vbox.append (format_area);
            vbox.append (history_label);
            vbox.append (history_buttons);
            vbox.append (pick_button);


            /* We want the color preview area to span the entire height of the
               window, so using a custom grid layout for the entire window
               including the headerbar */
            var window_grid = new Gtk.Grid ();
            window_grid.attach (headerbar, 0, 0);
            window_grid.attach (vbox, 0, 1);
            window_grid.attach (color_preview, 1, 0, 1, 2);

            /* As the headerbar spans only half the window, it would be
               more convenient to be able to move the window from anywhere */
            var window_handle = new Gtk.WindowHandle () {
                child = window_grid
            };

            /* when the app is opened the user probably wants to pick the color
               straight away. So setting the pick button as focused default
               action so that pressing Return or Space starts the pick */
            set_focus (pick_button);

            child = window_handle;


                        /* The toasts coming up over the half with the controls looks nicer
               than coming up over the middle of the whole window */
            //toast. = vbox;
            //toast.show ();
            pick_button.clicked.connect (() => {
                application.lookup_action (Application.ACTION_START_PICK).activate (null);
            });
        }

        public void show_toast (string message) {
            toast.title = message;
            toast.send_notification ();
        }


    }
}
