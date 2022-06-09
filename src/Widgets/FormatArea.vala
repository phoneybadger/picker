/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class FormatArea : Gtk.Box {
        public Picker.Color color {get; set;}
        public Format color_format {get; set;}

        private Gtk.ComboBoxText format_selector;
        private Gtk.Entry format_entry;

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

            format_entry.icon_press.connect (copy_to_clipboard);
        }

        private void handle_active_format () {
            notify ["color-format"].connect (update_entry);

            format_selector.changed.connect (() => {
                color_format = (Format) format_selector.active;
            });
        }

        private void sync_ui_with_controller () {
            var color_controller = ColorController.get_instance ();

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
            format_entry.set_icon_from_icon_name (
                Gtk.EntryIconPosition.SECONDARY,
                "edit-copy-symbolic"
            );

            format_selector = new Gtk.ComboBoxText ();
            foreach (var format in Format.all ()) {
                format_selector.append_text (format.to_string ());
            }

            pack_start (format_entry);
            pack_start (format_selector);
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
                default:
                    format_entry.text = color.to_rgba_string ();
                    break;
            }
        }

        private void copy_to_clipboard () {
            /* send a toast notification to give visual feedback to user */
            var toast_overlay = ToastOverlay.get_instance ();
            toast_overlay.show_toast (_("Copied to clipboard"));

            var clipboard = Gtk.Clipboard.get_default (this.get_display ());
            clipboard.set_text (format_entry.text, -1);
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
