#!/usr/bin/python3

    # This file is part of screc.

    # screc is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # screc is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with screc.  If not, see <https://www.gnu.org/licenses/>.
    
# Copyright Ulvican Kahya aka ulville 2021

import gi
gi.require_version('Notify', '0.7')
from gi.repository import Notify
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
import os
import sys

# Define a callback function
def show_in_dir(*args, **kwargs):
    os.system("xdg-open /run/media/ulvican/LinuxData/Ekran\ Kaydi")
    Gtk.main_quit()

def onClose(self):
    print("Notification closed!")
    Gtk.main_quit()

Notify.init("Screencast")
notification = Notify.Notification.new(str(sys.argv[1]), str(sys.argv[2]), "screen-shared")
notification.add_action("action_click", "Konumunu Aç", show_in_dir, None)
notification.add_action("default", "Konumunu Aç", show_in_dir, None)
notification.connect("closed", onClose)
notification.show()
    
Gtk.main()
