/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Cherrypick {
    public class FormatArea : Gtk.Box {
        public Cherrypick.Color color {get; set;}
        public Format color_format {get; set;}

        private Gtk.ComboBoxText format_selector;
        private Gtk.Entry format_entry;

        Cherrypick.ColorController color_controller;

        public signal void copied ();
        public signal string pasted (string pasted_text);

        public FormatArea () {
            Object (
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 10
            );
        }

        construct {
            create_layout ();
            load_format_from_gsettings ();
            sync_ui_with_controller ();
            handle_active_format ();

            notify ["color-format"].connect (save_format_to_gsettings);

            format_entry.icon_press.connect (copy_to_clipboard);
        }

        private void handle_active_format () {
            notify ["color-format"].connect (update_entry);

            format_selector.changed.connect (() => {
                color_format = (Format) format_selector.active;
            });
        }

        private void sync_ui_with_controller () {
            color_controller = ColorController.get_instance ();

            color_controller.notify ["preview-color"].connect (() => {
                color = color_controller.preview_color;
            });
            notify ["color"].connect (update_entry);

            realize.connect (() => {
                color = color_controller.preview_color;
            });
        }

        private void create_layout () {
            format_entry = new Gtk.Entry () {
                editable = false,
            };

            format_entry.primary_icon_name = "edit-copy-symbolic";
            format_entry.secondary_icon_name = "edit-paste-symbolic";

            format_selector = new Gtk.ComboBoxText ();
            foreach (var format in Format.all ()) {
                format_selector.append_text (format.to_string ());
            }

            format_entry.icon_press.connect ((icon_pos) => {
                if (icon_pos == Gtk.EntryIconPosition.PRIMARY) {
                    copy_to_clipboard ();
                } else {
                    paste_from_clipboard ();
                }
            });

            append (format_entry);
            append (format_selector);
        }

        private void update_entry () {
            if (color == null) {
                return;
            }
            switch (color_format) {
                case Format.HEX:
                    format_entry.text = color.to_hex_string ();
                    break;
                case Format.RGB:
                    format_entry.text = color.to_rgb_string ();
                    break;
                case Format.RGBA:
                    format_entry.text = color.to_rgba_string ();
                    break;
                case Format.CMYK:
                    format_entry.text = color.to_cmyk_string ();
                    break;
                case Format.HSL:
                    format_entry.text = color.to_hsl_string ();
                    break;
                default:
                    format_entry.text = color.to_rgba_string ();
                    break;
            }
        }

        private void copy_to_clipboard () {
            /* send a toast notification to give visual feedback to user */
            //var toast_overlay = ToastOverlay.get_instance ();
            //toast_overlay.show_toast (_("Copied to clipboard"));

            var clipboard = Gdk.Display.get_default ().get_clipboard ();
            clipboard.set_text (format_entry.text);
            this.copied ();
        }

        private void paste_from_clipboard () {
            var clipboard = Gdk.Display.get_default ().get_clipboard ();
            clipboard.read_text_async.begin ((null), (obj, res) => {
                try {

                    var pasted_text = clipboard.read_text_async.end (res);
                    /* Clean up a bit this mess as the user is likely to have copied unwanted strings with it */
                    string[] clutter_chars = {" ", "\n", ";"};
                    foreach (var clutter in clutter_chars) {
                        pasted_text = pasted_text.replace (clutter, "");
                    }

                    var picked_color = new Color ();
                    picked_color.parse (pasted_text);
                    color_controller.last_picked_color = picked_color;
                    color_controller.color_history.append (picked_color);

                    this.pasted (pasted_text);


                } catch (Error e) {
                    print ("Cannot access clipboard: " + e.message);
                }

            });
        }


        public void load_format_from_gsettings () {
            var settings = Settings.get_instance ();
            var format = settings.get_enum ("color-format");
            color_format = (Format) format;
            format_selector.active = color_format;
        }

        public void save_format_to_gsettings () {
            var settings = Settings.get_instance ();
            settings.set_enum ("color-format", color_format);
        }
    }
}
