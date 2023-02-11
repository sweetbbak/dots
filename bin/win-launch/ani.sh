#!/bin/bash

# Get the window ID of the kitty terminal
wid=$(xdotool search --class kitty)

# If the kitty terminal window is already open
if [ -n "$wid" ]; then
    # Minimize the window
    xdotool windowminimize $wid
else
    # Launch the kitty terminal with specific size and location
    kitty --geometry=200x200+100+100 &
fi

