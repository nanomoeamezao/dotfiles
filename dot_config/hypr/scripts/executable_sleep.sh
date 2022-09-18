#!/bin/bash
swayidle -w timeout 600 'hyprctl dispatch dpms off' \
	timeout 900 'systemctl suspend' \
	resume 'hyprctl dispatch dpms on' &
