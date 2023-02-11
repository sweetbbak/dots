#!/bin/sh

EWW=`which eww`
CFG="$HOME/.config/eww/pretty-bar/EWW-Widgets/eww/vertical-bar"

## Run eww daemon if not running already
if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 1
fi

## Open widgets 
run_eww() {
  ${EWW} -c $CFG close bar
  ${EWW} -c $CFG open bar
}

## Launch or close widgets accordingly
run_eww
