#!/bin/bash

asura="$HOME"/src/asura-bash/
html="$HOME"/src/asura-bash/asura-homepg
links="$HOME"/src/asura-bash/links.txt
thumbnails="$HOME"/src/asura-bash/images.txt
website="http://www.asurascans.com/"

# binary check, dep test, does this cmd exist
checkbin() {
	if ! command -v "$1" &>/dev/null
    then 
        echo "the dependency ${1} is not installed"
        exit
    fi
}

# Is this command help
is_help() {
	[ $# -eq 1 ] && ([ "$1" = "-h" ] || [ "$1" = "--help" ])
}

get_html() {
    wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -H "$1" -O asura-homepg
}

# Takes URL as an argument and downloads all the images from that site.
get_images() {

    wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" \
        -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$1"
}

strip_href() {
    grep -io '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
    sed -e 's/^<a href=["'"'"']//i' -e 's/["'"'"']$//i'
}

strip_img() {
    grep -io '<img src=['"'"'"][^"'"'"']*['"'"'"]' | \
sed -e 's/^<img src=["'"'"']//i' -e 's/["'"'"']$//i'
}

lastup=$(stat -c %Y "$HOME"/src/asura-bash/links.txt)
now=$(date +%s)
age=$((now - lastup))

if (( age > 1850 )) || [ -f "$links" ]; then

# returns a list of  'a' tags w/links + text theres 3 lines per tag
get_html "$website"
# rm index.html
temp=$(mktemp)
cat "$html" | pup 'ul[class="Manhwa"]' | pup "a" > "$temp"

# trim the tags and the text and give us just the links
cat "$temp" | grep -io '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
sed -e 's/^<a href=["'"'"']//i' -e 's/["'"'"']$//i' > "$links" 

# regex for getting just the names from the links:
# cat links.txt | cut -d '/' -f4 | sed 's/-chapter-.*//' | uniq

rm "$temp"
# going back to the html to rip the images (idk what to do w/them yet)
# and I shouldn't separate these two steps otherwise matching 
# links to img links could be messy
# note that this is likey overkill and consider using just sed/grep/awk
cat "$html" | pup 'a[class="series"]' | \
pup 'img[class="ts-post-image wp-post-image attachment-post-thumbnail size-post-thumbnail"]' | \
grep -io '<img src=['"'"'"][^"'"'"']*['"'"'"]' | \
sed -e 's/^<img src=["'"'"']//i' -e 's/["'"'"']$//i' > "$thumbnails"

fzf --reverse --cycle "$(cat links.txt | cut -d '/' -f4 | sed 's/-chapter-.*//' | uniq)"
