namespace Picker {
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
}
