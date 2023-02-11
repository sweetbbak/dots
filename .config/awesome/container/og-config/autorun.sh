#!/bin/sh

run() {
    if ! pgrep -f "$1" ;
    then
        $@ &
    fi
}

run "picom"
# run "/usr/bin/dunst"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

run "nm-applet"
# run "nitrogen --restore"
run "sh ~/.screenlayout/arandr-layout.sh"

run "dex -a -s /etc/xdg/autostart:~/.config/autostart"
