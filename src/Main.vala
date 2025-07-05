/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
public int main (string[] args) {
    var picker = new Cherrypick.Application ();
    int status = picker.run (args);

    return status;
}
