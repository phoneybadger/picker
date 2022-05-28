/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class FormatArea : Gtk.Box {
        public Picker.Color color {get; set;}

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

        public Format active_format {get; set;}
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
            notify ["active-format"].connect (update_entry);

            format_selector.changed.connect (() => {
                active_format = (Format) format_selector.active;
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
            switch (active_format) {
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
            var clipboard = Gtk.Clipboard.get_default (this.get_display ());
            clipboard.set_text (format_entry.text, -1);
        }

        public void load_format_from_gsettings () {
            var settings = Settings.get_instance ();
            Format format;
            settings.get ("format", "i", out format);
            active_format = format;
            format_selector.active = active_format;
        }

        public void save_format_to_gsettings () {
            var settings = Settings.get_instance ();
            settings.set ("format", "i", active_format);
        }
    }
}
