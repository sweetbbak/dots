#!/bin/bash
# Get the current window and desktop data
    active_window_id=$(xdotool getactivewindow)
    window_name=$(xdotool getwindowname $active_window_id)
    display_width=$(xdotool getdisplaygeometry | awk -F "[[:space:]]+" '/ /{print $1}')
    display_height=$(xdotool getdisplaygeometry | awk -F "[[:space:]]+" '/ /{print $2}')
    window_width=$(xdotool getwindowgeometry $active_window_id | awk -F "[[:space:]x]+" '/Geometry:/{print $3}')
    window_height=$(xdotool getwindowgeometry $active_window_id | awk -F "[[:space:]x]+" '/Geometry:/{print $4}')
    window_y_pos=$(xdotool getwindowgeometry $active_window_id | awk -F "[[:space:],]+" '/Position:/{print $4}')
    window_x_pos=$(xdotool getwindowgeometry $active_window_id | awk -F "[[:space:],]+" '/Position:/{print $3}')
    pointer_x=$(xdotool getmouselocation | awk -F "[[:space:]]" '//{print $1}' | awk -F "[:]" '//{print $2}')
    pointer_y=$(xdotool getmouselocation | awk -F "[[:space:]]" '//{print $2}' | awk -F "[:]" '//{print $2}')

# Current set of margin and border sizes with gtk3-nocsd installed:
    top_margin=3        # provodes a comfortable close fit to top of screen
    side_margin=3       # provides a comfortable close fit to sides.
    bottom_margin=3     # provides a comfortable close fit to bottom of screen. Increase by frame size 0 -10 (px) if frame borders are enabled
    border_y=29         # The size of the window top frame added to window when positioning (QT)  and virtual bottom (GTK)
    border_gtk=12       # The virtual offset size of window top frame for non QT windows ($gtk_fix)
    margin_delta=22     # Step delta for left/right and top margin
    width_steps=42      # Step divider to width of screen width
    height_steps=32     # Step divider to height of screen height
    height_delta=42     # Y delta zoom step

# Support for 2 screens extending display to 2nd screen to right with the same resolution (2 x 1920x1080)
    side_offset=0       # Offset for second screen window_x_pos calculations.
    if [ $window_x_pos -gt $(($display_width - $border_gtk - $side_margin)) ] ; then
        side_offset=$display_width
        window_x_pos=$(($window_x_pos - $display_width))
    fi
#echo "window_x_pos - "$window_x_pos" side_offset - "$side_offset ----  - $border_gtk

# Detect QT windows which do not need any position fiddles to compensate for windowmove positioning by frame coords for GTK built apps
# With QT windows we add header_height and for GTK both gtk_fix for header and footer_height to compensate for a dummy footer border! 

    if [ "$(echo $window_name | grep -c  "Konsole\|Dolphin\|Kate\|Octopi\|Session\|System\|HeidiSQL\|qBittorrent\|Clementine\|digiKam\|Okular\|KeePassXC\|Krusader\|LibreOffice\|Telegram\|Krusader\|LibreOffice\|Back\ In\ Time\|Kaffeine\|KDiff3\|Volume\|KDE Menu Editor\|KDevelop") " -gt 0 ] ; then
        gtk_fix=0
        footer_height=0
        header_height=$border_y
        app_type="QT-app"
    elif [ "$(echo $window_name | grep -c  "Twitter\|WhatsApp\|Maps\|iPlayer\|Calendar\|Google Photos\|Podcasts\|RadioFrance\|Zoom\|Deezer\|Arte\|Roundcube\|Google Drive\|Prime Video\|All 4\|Curzon\|Netflix\|Skype\|Gmail\|Google Meet\|EasyEffects")" -gt 0  ] ; then
        gtk_fix=0
        footer_height=-32
        header_height=-10
        side_margin=-14
        app_type="GTK-app Chrome Headless"
    else
        gtk_fix=29
        footer_height=$border_y
        header_height=$border_y
        app_type="GTK-apps"
    fi

# Function windowheight provides window height adjustment from the bottom in steps by pixel amaount 
# parameters: $1 <top margin>, $2 <side margin>, $3 <window header>,  $4 <GTK header fix>, $4 <step in pixels>, $5 <direction 1=increase> 
function windowheight () {

    window_fit_height=$(($display_height - $window_y_pos - $2))
    window_min_height=$(($window_fit_height * 9 / 32))
    window_delta=$(($window_fit_height / $3))
    
    if [ "$window_name" != "Desktop — Plasma" ]; then
            if [ $5 == 1 ]; then
                    window_new_height=$(($window_height + $window_delta))
                    if [ $window_new_height -gt $window_fit_height ]; then
                        window_new_height=$window_fit_height
                    fi
            else
                    window_new_height=$(($window_height - $window_delta))
                    if [ $window_new_height -lt $window_min_height ]; then
                        window_new_height=$window_min_height
                    fi
            fi
            xdotool windowsize --sync $active_window_id $window_width $window_new_height
            xdotool windowmove --sync $active_window_id 'x' $window_y_pos
            if [ $(($pointer_y + $window_delta)) -ge $(($window_new_height + $window_y_pos)) ]; then
                xdotool mousemove $pointer_x $(($window_new_height + $window_y_pos))
            fi
    fi

 }

# Function windowtop provides a top margin expand/contract function in steps by pixel amaount
# parameters: $1 <top margin>, $2 <side margin>, $3 <window header>,  $4 <GTK header fix>, $5 <step in pixels>, $6 <direction 1=increase> 
function windowtop () {

    y_multiplier=$(($(($window_y_pos - $1 - $3)) / $5 ))
    window_fit_pos=$(( $display_height - $1 - $2 ))
    top_margin=$(($1 + $3 - $4))

    if [ "$window_name" != "Desktop — Plasma" ]; then
        if  [ $6 -eq 1 ]; then
            window_y_new_pos=$(( $(($(($y_multiplier + 1)) * $5)) + $top_margin))
            window_base_pos=$(( $window_height + $window_y_pos))
            window_fit_height=$(($display_height - $window_y_new_pos - $2 - $footer_height))
            if [ $window_height -gt $window_fit_height ] || [ $window_base_pos -gt $window_fit_pos ] ; then
                window_height=$window_fit_height
            fi
        else
             if [ $y_multiplier -eq 0 ]; then
                    window_y_new_pos=$top_margin
            else
                    window_y_new_pos=$(( $(($(($y_multiplier - 1)) * $5)) + $top_margin))
            fi
            window_base_pos=$(( $window_height + $window_y_pos))
            window_fit_height=$(($display_height - $window_y_new_pos - $2 - $footer_height))
            if [ $window_height -gt $window_fit_height ] || [ $window_base_pos -gt $window_fit_pos ] ; then
                window_height=$(($window_fit_height))
            fi
        fi
        xdotool windowsize --sync $active_window_id $window_width $window_height
        xdotool windowmove --sync $active_window_id 'x' $window_y_new_pos
        xdotool mousemove $pointer_x $(($pointer_y + $window_y_new_pos - $window_y_pos + $gtk_fix))
    fi

 }

# Function windowwidth provides a width expand/contract function in steps proportional to screen width
# parameters: $1 <side margin>, $2 <window_x_pos>, $3 <window_y_pos>, $4 <header height>, $5 <gtk_fix>, $6 <width step delta>, $7 <footer height>, $8 <direction 1=increase> 
function windowwidth () {

    window_fit_width=$(($display_width - $((2 * $1))))
    window_delta=$(($window_fit_width / $6))
    window_y_new_pos=$($3 - $4)
    window_x_pos=$2

    if [ "$window_name" != "Desktop — Plasma" ]; then
            if [ $8 == 1 ]; then
                    window_new_width=$(($window_width + $window_delta))
                    window_x_new_pos=$(($window_x_pos - $(($window_delta / 2))))
                    if [ $window_new_width -ge $window_fit_width ]; then
                        window_new_width=$window_fit_width
                        window_x_new_pos=$1
                    elif [ $window_x_pos -lt $(($window_delta / 2)) ]; then
                        window_x_new_pos=$1
                    elif [ $(($window_new_width + $window_x_new_pos)) -gt $window_fit_width ]; then
                        window_x_new_pos=$(($display_width - $window_new_width - $1))
                    fi
                    window_x_new_pos=$(($window_x_new_pos + $side_offset))
#                    echo "window_x_new_pos P - "$window_x_new_pos
                    xdotool windowmove --sync $active_window_id $window_x_new_pos $window_y_new_pos
                    xdotool windowsize --sync $active_window_id $window_new_width $window_height
            else
                    window_new_width=$(($window_width - $window_delta))
                    if [ $window_width -ge $window_fit_width ]; then
                        window_x_new_pos=$(($window_x_pos + $(($window_delta / 2))))
                    elif [ $(($window_x_pos + $window_width - $1)) -ge $window_fit_width ]; then
                        window_x_new_pos=$(($window_fit_width - $window_new_width + $1))
                    elif [ $(($window_x_pos)) -lt $(($window_delta / 2))  ]; then
                        window_x_new_pos=$1
                    else
                        window_x_new_pos=$(($window_x_pos + $(($window_delta / 2))))
                    fi
                    xdotool windowsize --sync $active_window_id $window_new_width $window_height
                    if [ $(xdotool getwindowgeometry $active_window_id | awk -F "[[:space:]x]+" '/Geometry:/{print $3}') -ne  $window_width ]; then
                        window_x_new_pos=$(($window_x_new_pos + $side_offset))
                        echo "window_x_new_pos M - "$window_x_new_pos
                        xdotool windowmove --sync $active_window_id $window_x_new_pos $window_y_new_pos
                    fi
                    if [ $pointer_x -ge $(($window_x_new_pos + $window_new_width - $window_delta))  ]; then
                        xdotool mousemove $(($window_x_new_pos + $window_new_width - $window_delta)) $pointer_y
                    elif [ $pointer_x -le $(($window_x_new_pos + $window_delta))  ]; then
                        xdotool mousemove $(($window_x_new_pos + $window_delta))  $pointer_y
                    fi
            fi        
    fi

 }

# Function windowzoom provides a zoom function centered and proportional to the screen size
# parameters: $1 <top margin>, $2 <side margin>, $3 <window header>, $4 <GTK header fix> ,  $5 <vertical step delta>, $6 <margin delta>, $7 <direction 1=increase> 
function windowzoom () {

    window_fit_height=$(($display_height - $1 - $1 - $3))
    window_fit_width=$(($display_width - $2 - $2))
    window_min_width=800
    window_min_height=450
    zoom_y_delta=$5
    if [ $window_width -ge $window_fit_width ] && [ $7 -eq 0 ]; then
        xdotool windowstate --remove MAXIMIZED_VERT $active_window_id  # Fixes maxed window V
        xdotool windowstate --remove MAXIMIZED_HORZ $active_window_id  # Fixes maxed window H
        zoom_x_delta=$(($6 * 2))
    else
        zoom_x_delta=$(($(($window_width * $5)) / $window_height))
    fi
    top_margin=$(($1 + $3 - $4))

    if [ "$window_name" != "Desktop — Plasma" ]; then
        if  [ $7 -eq 1 ]; then
            if [ $window_width -lt  $(($window_fit_width - $zoom_x_delta)) ]; then            
                window_new_width=$(($window_width + $zoom_x_delta))
            else
                window_new_width=$(($window_fit_width))
            fi
            if [ $window_height -lt  $(($window_fit_height - $zoom_y_delta)) ]; then            
                window_new_height=$(($window_height + $zoom_y_delta))
            else
                window_new_height=$(($window_fit_height))
            fi
            if [ $(($window_new_width + $window_x_pos - $2)) -lt $window_fit_width ]; then
                window_x_new_pos=$window_x_pos
            else
                window_x_new_pos=$(($window_fit_width - $window_new_width + $2))
            fi
            if [ $(($window_new_height + $window_y_pos - $1)) -ge $window_fit_height ]; then
                window_y_new_pos=$top_margin
            else
                window_y_new_pos=$(($window_y_pos))
            fi
            window_x_new_pos=$(($window_x_new_pos + $side_offset))
            xdotool windowmove --sync $active_window_id $window_x_new_pos $window_y_new_pos
            xdotool windowsize --sync $active_window_id $window_new_width $window_new_height
        else
            if [ $window_width -ge $(($window_min_width + $zoom_x_delta)) ]; then
                window_new_width=$(($window_width - $zoom_x_delta))
            else
                window_new_width=$(($window_min_width))
            fi
            if [ $window_height -ge $(($window_min_height + $zoom_y_delta)) ]; then
                window_new_height=$(($window_height - $zoom_y_delta))
            else
                window_new_height=$(($window_min_height))
            fi
            if [ $window_width -ge $window_fit_width ]; then
                window_x_new_pos=$(($6 + $2))
            else
                window_x_new_pos=$window_x_pos
            fi
            if [ $(($window_height + $top_margin)) -ge $window_fit_height ]; then
                window_y_new_pos=$(($6 + $top_margin))
            else
                window_y_new_pos=$(($window_y_pos))
            fi
            window_x_new_pos=$(($window_x_new_pos + $side_offset))
            xdotool windowsize --sync $active_window_id $window_new_width $window_new_height
            xdotool windowmove $active_window_id $window_x_new_pos $window_y_new_pos
        fi
        if [ $pointer_x -ge $(($window_x_new_pos + $window_new_width - $(($zoom_x_delta / 4)))) ]; then
            pointer_x=$(($window_x_new_pos + $window_new_width - $(($zoom_x_delta / 4))))
        elif [ $pointer_x -le $(($window_x_new_pos + $(($zoom_x_delta / 4)))) ]; then
            pointer_x=$(($window_x_new_pos + $(($zoom_x_delta / 4))))
        elif [ $pointer_y -ge $(($window_y_new_pos + $window_new_height - $zoom_y_delta))  ]; then
            pointer_y=$(($window_y_new_pos + $window_new_height - $(($zoom_y_delta / 2))))
        elif [ $pointer_y -le $(($window_y_new_pos + $zoom_y_delta)) ]; then
            pointer_y=$(($window_y_new_pos + $(($zoom_y_delta / 2))))
        fi
        xdotool mousemove $pointer_x $pointer_y
    fi

 }

# Function windowmove moves the window left/right/centre with step adjustments for left/right by step pixel steps
# parameters: $1 <top margin>, $2 <side margin>, $3 <bottom margin>, $4 <header height>, $5 <GTK fix>, $6 <horizontal step 1>, $7 <step 2>, $8 <step 3>, 
# $9 <direction 0:left 1:right 2:center> 
function windowmove () {
 
    window_y_new_pos=$(($window_y_pos - $5))
    window_fit_height=$(($display_height - $1 - $3))
    window_fit_width=$(($display_width - $2 - $2 + $5 +$5))

    if [ "$window_name" != "Desktop — Plasma" ]; then
        if [ $window_height -gt $window_fit_height ]; then
            window_new_height=$window_fit_height
            xdotool windowsize --sync $active_window_id $window_width $window_new_height
        fi
        if [ $9 -eq 0 ]; then
            if [ $window_x_pos -eq $2 ]; then
                window_x_new_pos=$(($6 + $2))
            elif [ $window_x_pos -eq $(($6 + $2)) ]; then
                window_x_new_pos=$(($7 + $2))
            elif [ $window_x_pos -eq $(($7 + $2)) ]; then
                window_x_new_pos=$(($8 + $2))
            else
                window_x_new_pos=$2
            fi 
        elif [ $9 -eq 1 ]; then
            if [ $window_x_pos -eq $(($display_width - $window_width - $2)) ]; then
                window_x_new_pos=$(($display_width - $window_width - $6 - $2))
            elif [ $window_x_pos -eq $(($display_width - $window_width - $6 - $2)) ]; then
                window_x_new_pos=$(($display_width - $window_width - $7 - $2))
            elif [ $window_x_pos -eq $(($display_width - $window_width - $7 - $2)) ]; then
                window_x_new_pos=$(($display_width - $window_width - $8 - $2))
            else
                window_x_new_pos=$(($display_width - $window_width - $2))
            fi
        elif [ $9 -eq 2 ]; then
            window_x_new_pos=$((($display_width - $window_width) /2 ))
        fi
        if [ $(($window_x_new_pos + $window_width)) -ge $window_fit_width ]; then
            window_x_new_pos=$(($window_fit_width - $window_width + $2))  
        fi
        if [ $window_x_new_pos -lt $2 ]; then
            window_x_new_pos=$2
        fi
        window_x_new_pos=$(($window_x_new_pos + $side_offset))
        xdotool windowmove --sync $active_window_id $window_x_new_pos $window_y_new_pos
        xdotool mousemove $(($pointer_x + $window_x_new_pos - $window_x_pos)) $pointer_y
    fi

 }

# Function minimize minimizes all other windows other than the active window to clear screen clutter 
 function minimize () {
 
    active_window_id=$(xdotool getwindowfocus)
    for window_id in $(xdotool search --onlyvisible ".*")
    do
        if [ $window_id != $active_window_id ]
        then
            xdotool windowminimize $window_id
        fi
    done
 }
 
# echo "app_type - "$app_type
 # Selector for functions with parameter sets. These can be adjusted to suit personal perferences.
 case $1 in
    moveL )
        windowmove $top_margin $side_margin $bottom_margin $header_height $gtk_fix $margin_delta $(($margin_delta * 2)) $(($margin_delta * 3)) 0 $side_offset
    ;;
    moveR )
        windowmove $top_margin $side_margin $bottom_margin $header_height $gtk_fix $margin_delta $(($margin_delta * 2)) $(($margin_delta * 3)) 1 $side_offset
    ;;
    moveC )
        windowmove $top_margin $side_margin $bottom_margin $footer_height $gtk_fix 0 0 0 2 $side_offset
    ;;
    zoomP )
        windowzoom $top_margin $side_margin $header_height $gtk_fix $height_delta $margin_delta 1 $side_offset
    ;;
    zoomM )
        windowzoom $top_margin $side_margin $header_height $gtk_fix $height_delta $margin_delta 0 $side_offset
    ;;
    widthM )
        windowwidth $side_margin $window_x_pos $window_y_pos $header_height $gtk_fix $width_steps $footer_height 0 $side_offset
    ;;  
    widthP )
        windowwidth $side_margin $window_x_pos $window_y_pos  $header_height $gtk_fix $width_steps $footer_height 1 $side_offset
    ;;  
    heightM )
        windowheight $top_margin $bottom_margin $height_steps $gtk_fix 1
    ;;  
    heightP )
        windowheight $top_margin $bottom_margin $height_steps $gtk_fix 0
    ;; 
    topP )
        windowtop $top_margin $bottom_margin $header_height $gtk_fix $margin_delta 1
        ;; 
    topM )
        windowtop $top_margin $bottom_margin $header_height $gtk_fix $margin_delta 0
        ;;
    minimize )
        minimize
    ;;    
    *)
    echo "Command not recognized! - Usage window-move.sh <command> <int. offset> . Commands moveL, moveR, moveC, zoomM, zoomP, widthM, widthP, heightM, heightP or winTop with integer offfset!"
    ;;
 esac
