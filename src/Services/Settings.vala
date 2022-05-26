namespace Picker {
    public class Settings: GLib.Settings {
        private static Settings? instance;

        public static Settings get_instance () {
            if (instance == null) {
                instance = new Settings ();
            }
            return instance;
        }

        private Settings () {
            Object (
                schema_id: "com.github.phoneybadger.picker"
            );
        }
    }
}
