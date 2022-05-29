/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    /* This class is directly derived from
    https://github.com/manexim/codecard/blob/efd6471e806e8ee76246330847d721c1909c10f0/src/Widgets/Overlay.vala */
    public class ToastOverlay: Gtk.Overlay {
        private static ToastOverlay? instance;
        public Granite.Widgets.Toast toast;

        public static ToastOverlay get_instance () {
            if (instance == null) {
                instance = new ToastOverlay ();
            }
            return instance;
        }

        private ToastOverlay () {
            toast = new Granite.Widgets.Toast ("");
            add_overlay (toast);
        }

        public void show_toast (string message) {
            toast.title = message;
            toast.send_notification ();
        }

        public void hide_toast () {
            toast.reveal_child = false;
        }
    }
}
