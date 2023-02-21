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
# exe picom --experimental-backends --config ~/.config/picom.conf
exe picom --config ~/.config/picom.conf
exe "$HOME/bin/set-keyrate.sh"

xrdb merge $HOME/.Xresources
