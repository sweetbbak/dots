#!/usr/bin/env bash

alacritty -e ~/github/ani-cli/ani-cli &

# Process ID of the process we just launched
PID=$!

# Window ID of the process...pray that there's     
# only one window! Otherwise this might break.
# We also need to wait for the process to spawn
# a window.
while [ "$WID" == "" ]; do
        WID=$(wmctrl -lp | grep $PID | cut "-d " -f1)
done
# Set the size and location of the window
# See man wmctrl for more info
wmctrl -i -r $WID -e 0,2600,50,550,300
