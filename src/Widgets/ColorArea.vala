namespace Picker {
    public class ColorArea : Gtk.DrawingArea {
        public Picker.Color color {get; set;}

        public ColorArea (int size = 220) {
            Object (
                height_request : size,
                width_request : size
            );
        }

        construct {
            notify ["color"].connect (queue_draw);
        }

        public override bool draw (Cairo.Context ctx) {
            int width = get_allocated_width ();
            int height = get_allocated_height ();

            // Draw circle:
            double center_x = width / 2.0;
            double center_y = height / 2.0;
            double radius = (int.min (width, height) / 2.0);
            double start_angle = 0;
            double end_angle = 2 * Math.PI;

            ctx.arc (center_x, center_y, radius, start_angle, end_angle);
            Gdk.cairo_set_source_rgba (ctx, color);
            ctx.fill ();

            return true;
        }
    }
}
