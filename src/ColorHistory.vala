namespace Picker {
    public class ColorHistory: Object, Gee.Traversable<Color>, Gee.Iterable<Color> {
        private Gee.LinkedList<Color> colors = new Gee.LinkedList<Color> ();
        public int size {get; set construct;}

        public ColorHistory (int size) {
            Object (
                size: size
            );
        }

        public void append (Color color) {
            /* Remember only the newest "size" number of values. Discard older
               ones */
            if (colors.size < size) {
                colors.add (color);
                return;
            }
            colors.remove_at (0);
            colors.add (color);
        }

        public new Color get (int index) {
            return colors[index];
        }

        public bool @foreach (Gee.ForallFunc<Color> color) {
            return iterator ().foreach (color);
        }

        public Gee.Iterator<Color> iterator () {
            return colors.iterator ();
        }
    }
}
