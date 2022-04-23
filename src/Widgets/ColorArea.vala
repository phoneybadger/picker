namespace Picker {
    public class ColorArea : Gtk.DrawingArea {
        public Gdk.RGBA color;

        public ColorArea (int size = 180) {
            Object (
                height_request : size,
                width_request : size
            );
        }

        construct {
            // Using one of the elementary palette colors as default
            color.parse ("#f37329");

            notify ["color"].connect (() => {
                print ("color change");
            });
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
