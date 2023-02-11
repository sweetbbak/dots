cd $(dirname $0)

function exe () {
    local cmd=$@
    if ! pgrep -x $cmd; then
        $cmd &
    fi
}

exe picom --config=./picom/picom.conf -b
# exe $HOME/.config/awesome/scripts/redshift.sh restore
exe "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

exe "$HOME/.screenlayout/arandr-layout.sh"

xrdb merge $HOME/.Xresources
