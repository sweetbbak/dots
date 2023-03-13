#!/bin/sh

# add more args here according to preference
ARGS="--no-video"

notification(){
# change the icon to whatever you want. Make sure your notification server 
# supports it and already configured.

# Now it will receive argument so the user can rename the radio title
# to whatever they want

	notify-send "Playing now: " "$@" --icon=media-tape
}

# number of the stream as per the $choice variable
# name of the stream
# additional tag to filter similar type of streams

menu(){
	printf "1. Lofi Girl <lofi>\n"
	printf "2. Chillhop <lofi>\n"
	printf "3. Box Lofi <lofi>\n"
	printf "4. The Bootleg Boy <lofi>\n"
	printf "5. Radio Spinner <lofi>\n"
	printf "6. Dreamhop <lofi>\n"
	printf "7. NDTV 24x7 <news>\n"
	printf "8. WION Live <news>\n"
	printf "9. Nirvana Shatakam <aadhyatama>\n"
}

main() {
	choice=$(menu | rofi -dmenu | cut -d. -f1)

	case $choice in
		1)
			notification "Lofi Girl ☕️🎶";
            URL="https://youtu.be/jfKfPfyJRdk"
	    ADDITIONAL_ARGS="--volume=60"
			break
			;;
		2)
			notification "Chillhop ☕️🎶";
            URL="https://youtu.be/7NOSDKb0HlU"
	    ADDITIONAL_ARGS="--volume=60"
			break
			;;
		3)
			notification "Anime Lofi nostalgic ☕️🎶";
            URL="https://youtu.be/WDXPJWIgX-o"
	    ADDITIONAL_ARGS="--volume=60"
			break
			;;
		4)
			notification "The Bootleg Boy ☕️🎶";
            URL="https://youtu.be/WIU-A596KKU"
	    ADDITIONAL_ARGS="--volume=60"
			break
			;;
		5)
			notification "Radio Spinner ☕️🎶";
            URL="https://live.radiospinner.com/lofi-hip-hop-64"
	    ADDITIONAL_ARGS="--volume=60"
			break
			;;
		6)
			notification "Dreamhop ☕️🎶";
            URL="https://youtu.be/wkhLHTmS_GI"
	    ADDITIONAL_ARGS="--volume=60"
			break
			;;
		7)
			notification "NDTV 24x7 📰";
            URL="https://youtu.be/WB-y7_ymPJ4"
	    ADDITIONAL_ARGS=""
			break
			;;
		
		8)
			notification "WION Live 📰"
            URL="https://youtu.be/3JlVqzNSYys"
	    ADDITIONAL_ARGS=""
			break
			;;

		9)
			notification "Lofi;
            URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"
	    ADDITIONAL_ARGS="--loop"
			break
			;;
		
		esac
    # run mpv with args and selected url
    # added title arg to make sure the pkill command kills only this instance of mpv
    mpv $ARGS --title="radio-mpv" $URL $ADDITIONAL_ARGS
}

pkill -f radio-mpv || main
