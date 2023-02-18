#!/bin/sh

# dir for cached thumbnails
cachedir="$HOME/.cache/pinterest"
# nsxiv options
sxiv_opts=" -tfpo -z 200"

# menu command when no query is provided
sh_menu() {
  rofi -dmenu -l 0 -p "search pinterest"
}

#################
## search query##
#################

[ -n "$*" ] && query="$*" || query=$( sh_menu )
[ -z "$query" ] && exit 1
query=$(printf '%s' "$query" | sed "s|^ ||;s| |%20|g")

##############
## start up ##
##############

rm -rf "$cachedir"
mkdir -p "$cachedir"

# progress display command
sh_info () {
	printf "%s\n" "$1" >&2
	notify-send "wallhaven" "$1"
	[ -n "$2" ] && exit "$2"
}

# dependency checking
dep_ck () {
	for pr; do
		command -v $pr >/dev/null 2>&1 || sh_info "command $pr not found, install: $pr" 1
	done
}
dep_ck "nsxiv" "curl"


# clean up command that would be called when the program exits
clean_up () {
	printf "%s\n" "cleaning up..." >&2
	rm -rf "$datafile" "$cachedir"
}

# file to store links from pinterest
datafile="/tmp/pint.$$"

# clean up if interrupted
trap "exit" INT TERM
trap "clean_up" EXIT

##############
## get data ##
##############

get_results() {
  results="$(curl -s "https://www.pinterest.com/resource/BaseSearchResource/get/?source_url=%2Fsearch%2Fpins%2F%3Fq%3Dtyped&data=%7B%22options%22%3A%7B%22query%22%3A%22$query%22%2C%22scope%22%3A%22pins%22%2C%22filters%22%3A%22%22%7D%2C%22context%22%3A%7B%7D%7D&_=1675012790871" | tr "," "\n" | sed -nE "s@\"url\":\"(https:\/\/i\.pinimg\.com/originals.*\.jpg)\".*@\1@p")"
  printf "%s\n" "$results" >> "$datafile"
  sleep 1.001
}

# search images
sh_info "getting images..."
# get_results "$query"

# check if data file is empty, if so then exit
[ -s "$datafile" ] || sh_info "No images found" 1

##########################
## downloading thumbnails#
##########################

# get a list of thumbnails
thumbnails=$( cat "$datafile"i )
[ -z "$thumbnails" ] && sh_info "no results" 1

# download
sh_info "caching images..."
for link in $thumbnails
do
  printf "url = %s\n" "$link" 
  printf "output = %s\n" "$cachedir/${link##*/}"
# done | curl -Z -K -
done | lolcat

####################
## user selection ##
####################

image_ids="$(nsxiv $sxiv_opts "$cachedir")"
[ -z "$image_ids" ] && exit

# query="$(printf "%s" "$*" | sed "s|^ ||;s| |%20|g")"
# results="$(curl -s "https://www.pinterest.com/resource/BaseSearchResource/get/?source_url=%2Fsearch%2Fpins%2F%3Fq%3Dtyped&data=%7B%22options%22%3A%7B%22query%22%3A%22$query%22%2C%22scope%22%3A%22pins%22%2C%22filters%22%3A%22%22%7D%2C%22context%22%3A%7B%7D%7D&_=1675012790871" | tr "," "\n" | sed -nE "s@\"url\":\"(https:\/\/i\.pinimg\.com/originals.*\.jpg)\".*@\1@p")"
