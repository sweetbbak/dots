#!/usr/bin/env bash

DIR="$HOME/.config/polybar/makima"
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -q makima -c "$DIR"/config.ini &
polybar -q makima -c "$DIR"/config-0.ini &
polybar -q makima -c "$DIR"/config-1.ini &

# checks monitors
# if type "xrandr"; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar --reload makima &
#   done
# else
#   polybar --reload makima &
# fi
# for m in $(polybar --list-monitors | cut -d":" -f1); do
#     MONITOR=$m polybar --reload makima &
# done