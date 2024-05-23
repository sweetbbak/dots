#!/usr/bin/env bash
#
# wallfile=/tmp/wallpaper-33
wallfile=/home/sweet/.cache/wallpaper-33

picdir="$HOME/Pictures/backgrounds"
[ ! -d "$picdir" ] && picdir="$HOME/ssd/gallery-dl"

randomimg() {
    # newline separated string of images
    images="$(fd . "$picdir" --absolute-path -e gif -e png -e jpg)"
    # pick a random image
    image="$(printf "%s\n" "${images[@]}" | shuf -n 1)"
    # clean image of spaces
    image="${image// /}"
    # temp file with last known wallpaper
    image_old="$(cat "$wallfile")"

    # if file not exists, use swww query to get current image
    [ -z "${image_old}" ] && {
        image_old="$(swww query | grep -o "image: .*"| head -n1 | sed -e "s/image: //g" -e 's/\"//g')" 
    }
    # shuffle image until image is not equal to the previous image
    while [[ "$image" = "$image_old" ]]; do
        image="$(printf "%s\n" "${images[@]}" | shuf -n 1)"
    done

    # if image path does not exist then exit else set as bg :)
    [ ! -f "$image" ] && echo "Image not found" && exit 1
    swww img "${image}" --transition-type center
    # input current image into temp file
    echo "${image}" > "$wallfile"
}
case "$1" in
    list|get|-l|--list)
        # get image
        printf "%s" "$(swww query | grep -o "image: .*")" 
        ;;
    set|set-bg)
        image="${2}"
        [ ! -f "$image" ] && echo "Image not found" && exit 1
        swww img "${image}" --transition-type center
        echo "${image}" > "$wallfile"
        ;;
    random) 
        randomimg
        ;;
    gif) 
        image="$(fd . "$picdir" --absolute-path -e gif | shuf -n 1)"
        [ ! -f "$image" ] && echo "Image not found" && exit 1
        swww img "${image}" --transition-type center
        echo "${image}" > "$wallfile"
        ;;
    pick)
        kitty --class "catnip3" -e ~/bin/cn ~/Pictures/backgrounds
        ;;
    prev)
        image="$(cat "$wallfile")"
        image="${image// /}"
        [ -z "${image}" ] && echo "${wallfile} is empty"
        [ ! -f "$image" ] && echo "Image not found" && exit 1
        swww img "${image}" --transition-type center
        ;;
    *) 
        image="$(cat "$wallfile")"
        [ -z "${image}" ] && {
        image="$(swww query | grep -o "image: .*"| head -n1 | sed -e "s/image: //g" -e 's/\"//g')" 
        }
        ;;
esac

printf '{"text": "%s", "tooltip": "%s"}' \
    "" "$image"
