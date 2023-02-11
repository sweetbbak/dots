#!/bin/sh

get_input() {
  [ -z "$*" ] && query=$(gum input --placeholder "Search for a subreddit") || query=$*
  query=$(printf "%s" "$query"|tr ' ' '+')
  subreddit=$(curl -sL "https://www.reddit.com/search/?q=${query}&type=sr"|tr "<" "\n"|
    sed -nE 's@.*class="_2torGbn_fNOMbGw3UAasPl">r/([^<]*)@\1@p'|gum filter)
  xml=$(curl -s "https://www.reddit.com/r/$subreddit.rss" -A "uwu"|tr "<|>" "\n")

  post_href=$(printf "%s" "$xml"|sed -nE '/media:thumbnail/,/title/{p;n;p;}'|
    sed -nE 's_.*href="([^"]+)".*_\1_p;s_.*media:thumbnail[^>]+url="([^"]+)".*_\1_p; /title/{n;p;}'|
    sed -e 'N;N;s/\n/\t/g' -e 's/&amp;/\&/g'|grep -vE '.*\.gif.*')
  [ -z "$post_href" ] && printf "No results found for \"%s\"\n" "$query" && exit 1
}

readc() {
  if [ -t 0 ]; then
    saved_tty_settings=$(stty -g)
    stty -echo -icanon min 1 time 0
  fi
  eval "$1="
  while
    c=$(dd bs=1 count=1 2> /dev/null; echo .)
    c=${c%.}
    [ -n "$c" ] &&
        eval "$1=\${$1}"'$c
    [ "$(($(printf %s "${'"$1"'}" | wc -m)))" -eq 0 ]'; do
    continue
  done
  [ -t 0 ] && stty "$saved_tty_settings"
}

download_image() {
  downloadable_link=$(curl -s -A "uwu" "$1"|sed -nE 's@.*class="_3Oa0THmZ3f5iZXAQ0hBJ0k".*<a href="([^"]+)".*@\1@p')
  curl -s -A "uwu" "$downloadable_link" -o "$(basename "$downloadable_link")"
  [ -z "$downloadable_link" ] && printf "No image found\n" && exit 1
  tput clear && gum style \
      --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
          'Your image has been downloaded!' "Image saved to $(basename "$downloadable_link")"
  # shellcheck disable=SC2034
  printf "Press Enter to continue..." && read -r useless
}

cleanup() {
  tput cnorm && exit 0
}

trap cleanup EXIT INT HUP
get_input "$@"

i=1 && tput clear
while true; do
  tput civis
  [ "$i" -lt 1 ] && i=$(printf "%s" "$post_href"|wc -l)
  [ "$i" -gt "$(printf "%s" "$post_href"|wc -l)" ] && i=1
  link=$(printf "%s" "$post_href"|sed -n "$i"p|cut -f1)
  post_link=$(printf "%s" "$post_href"|sed -n "$i"p|cut -f2)
  gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align left --width 50 --margin "20 1" --padding "2 4" \
    'Press (j) to go to next' 'Press (k) to go to previous' 'Press (d) to download' \
    'Press (o) to open in browser' 'Press (s) to search for another subreddit' 'Press (q) to quit'
  kitty +kitten icat --scale-up --place 60x40@69x3 --transfer-mode file "$link"
  readc key
  # shellcheck disable=SC2154
  case "$key" in
    j) i=$((i+1)) && tput clear ;;
    k) i=$((i-1)) && tput clear ;;
    d) download_image "$post_link" ;;
    o) xdg-open "$post_link" || open "$post_link" ;;
    s) get_input ;;
    q) exit 0 && tput clear ;;
    *) ;;
  esac
done
