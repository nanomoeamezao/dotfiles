#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
#if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
#    gnome-keyring-daemon --daemonize --login &
#fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi

# System-config-printer-applet is not installed in minimal edition
if (command -v system-config-printer-applet && ! pgrep applet.py ); then
  system-config-printer-applet &
fi

# run xfsettingsd
run nm-applet
run light-locker
run picom -b
#run lxpolkit
run batterymon -t numix 
run batsignal -f 95 -C "CHARGE ME FAGGOT" -m 320 -e -b
# run xcape -e 'Caps_Lock=Escape'
run thunar --daemon
# run pa-applet
# run pamac-tray
# blueman-applet and msm_notifier are not installed in minimal edition
run blueman-applet
# run msm_notifier
