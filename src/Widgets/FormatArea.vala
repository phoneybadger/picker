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
        private Gtk.Entry entry;

        construct {
            orientation = Gtk.Orientation.HORIZONTAL;

            entry = new Gtk.Entry () {
                editable = false,
            };
            entry.set_icon_from_icon_name (
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

            active_format = Format.RGB;
            format_selector.active = active_format;

            pack_start (entry, true, false, 10);
            pack_start (format_selector, false, false);
        }

        private void update_entry () {
            switch (active_format) {
                case Format.HEX:
                    entry.text = color.to_hex_string ();
                    break;
                case Format.RGB:
                    entry.text = color.to_rgb_string ();
                    break;
                case Format.RGBA:
                    entry.text = color.to_rgba_string ();
                    break;
                default:
                    entry.text = color.to_rgba_string ();
                    break;
            }
        }
    }
}
