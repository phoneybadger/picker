namespace Picker {
    public class ColorController : Object {
        public Picker.Color active_color {get; set;}
        public Picker.Color picked_color {get; set;}


        construct {
            notify ["picked-color"].connect (() => {
                active_color = picked_color;
            });
        }
    }
}
