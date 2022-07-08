# screc

This is a shell script I use to record my screen in both Xorg and GNOME-Wayland sessions.
Attach it to a keyboard shortcut for ease of use.

It uses ffmpeg under Xorg. I used Nvidia's NVENC encoding but you should change ffmpeg parameters for your needs.

It uses OBS, obs-websocket and obs-cli for recording on Wayland

If you're going to use it under Wayland create a .env file inside script directory and paste your obs-websocket password inside it.

## Warning:

Save directory path is hardcoded on screc-tgg.sh and other two .py files. Change it according to your needs.
