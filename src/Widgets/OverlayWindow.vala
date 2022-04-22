namespace Picker {
    public class OverlayWindow : Gtk.Window {
        /* Transparent composited window that stays on top */
        public signal void cursor_moved (int x, int y);

        private int mouse_x;
        private int mouse_y;

        construct {
            app_paintable = true;
            resizable = false;
            deletable = false;
            skip_taskbar_hint = true;
            skip_pager_hint = true;
            type = Gtk.WindowType.POPUP;
            set_keep_above (true);
            stick ();
            set_visual (get_screen ().get_rgba_visual ());

            var display = Gdk.Display.get_default ();
            var monitor = display.get_primary_monitor ();
            var geometry = monitor.get_geometry ();

            default_height = geometry.height;
            default_width = geometry.width;

            add_events (
                Gdk.EventMask.POINTER_MOTION_MASK
            );

        }

        /* Overriding events instead of listening to them because we are using
        a POPUP window and some events don't always work properly with that */
        public override bool motion_notify_event (Gdk.EventMotion event) {
            on_mouse_moved (event);
            return true;
        }

        private void on_mouse_moved (Gdk.Event event) {
            if (event.type == Gdk.EventType.MOTION_NOTIFY) {
                var x = event.motion.x;
                var y = event.motion.y;

                /* The event might be triggered for motion corresponding to
                fractional pixels, but we are not interested in those for our
                purpose */
                if (Math.fabs (mouse_x - x) > 1 ||
                    Math.fabs (mouse_y - y) > 1) {
                    mouse_x = (int) x;
                    mouse_y = (int) y;

                    cursor_moved (mouse_x, mouse_y);
                }
            }
        }
    }
}
