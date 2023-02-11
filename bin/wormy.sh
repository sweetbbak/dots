#!/bin/sh

# . $HOME/.wmvar

INPUT=$1                   # input
FW=$(pfw)                  # focused window
SW=$(wattr w $(lsw -r))    # screen width
SH=$(wattr h $(lsw -r))    # screen height
MAXX=$((SW - WW))          # max X coordinate
MAXY=$((SH - WH))          # max Y coordinate
FREQ=5                     # refresh frequency

usage() {
    echo "usage:
wrm.sh [ -a, -f ]
-a) all windows
-f) focused window"
}


case $INPUT in
    -a)    # random movement for all windows
	while true; do
	    for wid in $(lsw); do
		x=$(shuf -i 0-$MAXX -n 1)    # random x coordinate
		y=$(shuf -i 0-$MAXY -n 1)    # random y coordinate
		wtp $x $y $WW $WH $wid 
	    done
	    sleep $FREQ
	done
	;;
    -f)    # movement for the focused window
	while true; do
	    x=$(shuf -i 0-$MAXX -n 1)
	    y=$(shuf -i 0-$MAXY -n 1)
	    wtp $x $y $WW $WH $FW
	    sleep $FREQ
	done
	;;
    *)
	usage
	;;
esac

