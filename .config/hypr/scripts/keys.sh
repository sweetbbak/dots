#!/bin/bash
config=~/.config/hypr/configs/keybinds.conf

OLDIFS="$IFS"

cleanup() {
    IFS="$OLDIFS"
}

trap cleanup EXIT INT SIGINT
declare -a hyprlandkeys

hyprlandkeys=(
exec
execr
pass
killactive
closewindow
workspace
movetoworkspace
movetoworkspacesilent
togglefloating
fullscreen
fakefullscreen
dpms
pin
movefocus
movewindow
swapwindow
centerwindow
resizeactive
moveactive
resizewindowpixel
movewindowpixel
cyclenext
swapnext
focuswindow
focusmonitor
splitratio
toggleopaque
movecursortocorner
movecursor
workspaceopt
renameworkspace
exit
forcerendererreload
movecurrentworkspacetomonitor
moveworkspacetomonitor
swapactiveworkspaces
bringactivetotop
togglespecialworkspace
focusurgentorlast
togglegroup
changegroupactive
focuscurrentorlast
lockgroups
moveintogroup
moveoutofgroup
global
)

in_array() {
    local haystack="${1}[@]"
    local needle=${2}

    for i in ${!haystack}; do
        if [[ ${i} == "${needle}" ]]; then
            return 0
        fi
    done
    return 1
}

declare -a binds
shopt -s extglob

while IFS='=' read -r lhs rhs
do
    if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
        rhs="${rhs%%\#*}"     # Del in line right comments
        rhs="${rhs%%*( )}"    # Del trailing spaces
        rhs="${rhs%\"*}"      # Del opening string quotes 
        rhs="${rhs#\"*}"      # Del closing string quotes 
        # declare $lhs="$rhs" # declare variables as actual variables 
        printf "[%s] = %s\n" "${lhs// /}" "${rhs// /}"
        case "$lhs" in
            bind) 
                binds+=("$rhs")
            ;;
            bindm) 
                binds+=("$rhs")
            ;;
        esac
    fi
done < "$config"

for x in "${binds[@]}"; do
    x="${x//,/ }"
    printf "%s\n" "$x"
done

printf "%s\n" "${binds[@]}" | wofi -d