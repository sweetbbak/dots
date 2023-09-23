#!/bin/bash

keys=$(hyprkeys -b -c "$HOME/.config/hypr/configs/keybinds.conf" -j |\
     jq '.Binds[] | "\(.Bind) \(.Command)"')

# printf "%s\n" "${keys[@]}" | sed "s/[',#,\`,@]//g" | wofi -d
printf "%s\n" "${keys[@]}" | sed 's/"//g' | wofi -d
