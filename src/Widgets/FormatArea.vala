namespace Picker {
    public class FormatArea : Gtk.Box {
        construct {
            orientation = Gtk.Orientation.HORIZONTAL;
            expand = false;
            halign = Gtk.Align.END;
            var entry = new Gtk.Entry () {
                text = "#FF0000",
                editable = false,
            };
            entry.set_icon_from_icon_name (
                Gtk.EntryIconPosition.SECONDARY,
                "edit-copy-symbolic"
            );

            var format_selector = new Gtk.ComboBoxText ();
            format_selector.append_text ("HEX");
            format_selector.append_text ("RGBA");
            format_selector.append_text ("RGB");

            pack_start (entry, true, false, 10);
            pack_start (format_selector, false, false);
        }
    }
}
