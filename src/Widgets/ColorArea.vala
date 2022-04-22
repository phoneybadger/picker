namespace Picker {
    public class ColorArea : Gtk.DrawingArea {
        public ColorArea (int size = 180) {
            Object (
                height_request : size,
                width_request : size
            );
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

            var color = Gdk.RGBA ();
            color.parse ("#F37329");

            ctx.arc (center_x, center_y, radius, start_angle, end_angle);
            Gdk.cairo_set_source_rgba (ctx, color);
            ctx.fill ();

            return true;
        }
    }
}
