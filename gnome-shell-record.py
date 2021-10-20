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

import time
import os
from pydbus import SessionBus
from gi.repository import GLib

bus = SessionBus()
GNOMEScreencast = bus.get('org.gnome.Shell.Screencast', '/org/gnome/Shell/Screencast')
filename = "/run/media/ulvican/LinuxData/Ekran\ Kaydi/wayland-video-temp.mp4"
RecorderPipeline = "x264enc pass=qual quantizer=0 speed-preset=ultrafast ! queue ! mp4mux"

def stopgnomerec():
    print("oççagalın ğidiom ben")
    GNOMEScreencast.StopScreencast()

print("GNOME-Wayland Record Starting")
GNOMEScreencast.Screencast(filename,
                            {'framerate': GLib.Variant('i', int(60)),
                             'draw-cursor': GLib.Variant('b', True),
                             'pipeline': GLib.Variant('s', RecorderPipeline)})

import atexit
atexit.register(stopgnomerec)
time.sleep(32400)
