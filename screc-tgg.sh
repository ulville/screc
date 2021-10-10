#!/usr/bin/bash

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

# This is a shell script I use to record my screen in both Xorg and GNOME-Wayland sessions
# Attach it to a keyboard shortcut for ease of use.

# Warning:
# Save directory path is hardcoded on this and other two .py files. Change it according to your needs

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function record_ffmpeg () {
	ffmpeg -f x11grab -thread_queue_size 512 -video_size hd1080 -framerate 60 -i $DISPLAY -f pulse -thread_queue_size 512 -i $PULSE_INPUT -pix_fmt yuv444p -c:v hevc_nvenc -b:v 35M -maxrate:v 50M -rc:v vbr -tune:v hq -multipass:v fullres -rc-lookahead:v 32 -spatial_aq:v 1 /run/media/ulvican/data/Ekran\ Kaydi/screenrecord_`date +%y%m%d-%H%M%S`.mp4 &
}

function record_audio () {
	ffmpeg -f pulse -thread_queue_size 512 -i $PULSE_INPUT /run/media/ulvican/data/Ekran\ Kaydi/wayland-audio-temp.mkv -y &
}

function record_wayland () {
	$SCRIPT_DIR/gnome-shell-record.py
}

function merge_a_v () {
	ffmpeg -i /run/media/ulvican/data/Ekran\ Kaydi/wayland-video-temp.mp4 -i /run/media/ulvican/data/Ekran\ Kaydi/wayland-audio-temp.mkv -c copy /run/media/ulvican/data/Ekran\ Kaydi/screenrecord_`date +%y%m%d-%H%M%S`.mp4
}

function mouse_led_default () {
	if lsusb | grep -q 'Logitech'; then
		ratbagctl 0 led 0 set mode on color 00536E
	elif ls /sys/class/leds | grep -q 'kbd_backlight'; then
		pkill blink-keyboard.
	fi
}

function mouse_led_recording () {
	if lsusb | grep -q 'Logitech'; then
		ratbagctl 0 led 0 set mode breathing duration 500 color ff0000 brightness 200
	elif ls /sys/class/leds | grep -q 'kbd_backlight'; then
		$SCRIPT_DIR/blink-keyboard.sh &
	fi
}

function mouse_led_wait () {
	if lsusb | grep -q 'Logitech'; then
		ratbagctl 0 led 0 set mode breathing duration 100 color ffff00 brightness 200
	fi
}


if pactl list short sources | grep -q 'easyeffects'; then
	PULSE_INPUT="easyeffects_sink.monitor"
else
	PULSE_INPUT="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
fi

# Eğer Wayland ise
# If it's wayland
if [ $XDG_SESSION_TYPE = "wayland" ]
then
	SERVICE="gnome-shell-rec"
	if pgrep -x "$SERVICE" >/dev/null
	then
		pkill -2 gnome-shell-rec
		pkill -2 ffmpeg
		notify-send "Wayland Ekran Kaydı" "Ekran Kaydı Durduruldu. Dosya İşleniyor..."
		mouse_led_wait
		sleep 10
		merge_a_v &&
		mouse_led_default
		sleep 1
		rm /run/media/ulvican/data/Ekran\ Kaydi/wayland-audio-temp.mkv
		rm /run/media/ulvican/data/Ekran\ Kaydi/wayland-video-temp.mp4
        $SCRIPT_DIR/action-notify.py "Kayıt Tamamlandı" ""
    	
    else
    	notify-send -i screen-shared "Ekran Kaydı Başlatıldı" "Ses kaynağı: $PULSE_INPUT  Pencere Sistemi: $XDG_SESSION_TYPE"
    	mouse_led_recording
		record_audio &
		record_wayland
    	
    fi

# Eğer Xorg ise
# If it's Xorg
else
	SERVICE="ffmpeg"


	if pgrep -x "$SERVICE" >/dev/null
	then
    	pkill ffmpeg
    	mouse_led_default
        $SCRIPT_DIR/action-notify.py "Ekran Kaydı Durduruldu" "Kayıt Tamamlandı"
	else
    	record_ffmpeg
		notify-send -i screen-shared "Ekran Kaydı Başlatıldı" "Ses kaynağı: $PULSE_INPUT  Pencere Sistemi: $XDG_SESSION_TYPE"
    	mouse_led_recording

		for i in 1 2 3 4 5
		do
			sleep 1
			if pgrep -x "$SERVICE" >/dev/null
			then
				:
			else
    			mouse_led_default
				pkill ffmpeg
				notify-send "Hata!" "Kayıt Başlatılamadı"
				break
			fi
		done


	fi
fi
