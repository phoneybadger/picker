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

        construct {
            orientation = Gtk.Orientation.HORIZONTAL;

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

            notify ["color"].connect (update_entry);
            notify ["active-format"].connect (update_entry);

            format_selector.changed.connect (() => {
                active_format = (Format) format_selector.active;
            });


            format_entry.icon_press.connect (copy_to_clipboard);

            pack_start (format_entry, true, false, 10);
            pack_start (format_selector, false, false);
        }

        private void update_entry () {
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

        public void load_format_from_config (GLib.Settings settings) {
            Format format;
            settings.get ("format", "i", out format);
            active_format = format;
            format_selector.active = active_format;
        }

        public void save_format_to_config (GLib.Settings settings) {
            settings.set ("format", "i", active_format);
        }
    }
}
