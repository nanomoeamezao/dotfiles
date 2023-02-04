#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
	if (command -v $1 && ! pgrep $1); then
		$@ &
	fi
}

# System-config-printer-applet is not installed in minimal edition
if (command -v system-config-printer-applet && ! pgrep applet.py); then
	system-config-printer-applet &
fi

run nm-applet
run picom -b
run udiskie
#run lxpolkit
if [ "$HOSTNAME" = "neotop" ]; then
	run blueman-applet
	run easyeffects --gapplication-service
	run plex-mpv-shim
	# run qbittorrent
fi
