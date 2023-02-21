anima() {
  animdl grab "$1" -r "$2" --index 1 | sed -nE 's|.*stream_url": "(.*)".*|\1|p'| cb copy
}


# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

neovidecloseterminal () {
	neovide "$@" && kitty & 
	exit
}

d() {
  # shows file and symlink
  hx "$(which $1)"
  file "$(which $1)"
}

ocr() {
  scrot -s -o -f '/home/sweet/Pictures/OCR.png' -e 'tesseract -l jpn $f stdout | xclip -selection clipboard && rm $f'
}

bkr() {
  (nohup "$@" &>/dev/null)
}

riz(){
  wmctrl -r :ACTIVE: -e "$(slop -f 0,%x,%y,%w,%h)"
}

get-windows() {
  wmctrl -lx | grep -E "$1" | grep -oE "[0-9a-z]{10}"
}

get_domain(){
	echo "$1" | sed -E 's#^https?://(www\.)?##; s#/.*##'
}

wget-imgs() {
  wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$@"
}

# Imagemagick
## Resize images
75%() { mogrify -resize '75%X75%' "$@" ; }
50%() { mogrify -resize '50%X50%' "$@" ; }
25%() { mogrify -resize '25%X25%' "$@" ; }
## Scan folder for images of a certain ratio

parurm() {
  SELECTED_PKGS="$(paru -Qsq | fzf --header='Remove packages' -m --height 100% --preview 'paru -Si {1}')"
  if [ -n "$SELECTED_PKGS" ]; then
    paru -Rns $(echo $SELECTED_PKGS)
  fi
}

#short for pathfinder :)
pthf()
{
  echo $PATH | sed 's/:/\n/g' | fzf
}

# ani-cli() {
#   ~/github/ani-cli/ani-cli
# }

icons() {
  selection=$(cat "$HOME"/.config/rofi/icons-list.txt | rofi -dmenu -i -markup-rows -p "" -columns 6 -width 100 -location 1 -lines 20 -bw 2 -yoffset -2 | cut -d\' -f2) 
  cat "$selection" | xsel
}

get-volume() {
  awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master)
}

slugify () {
    echo "$1" | iconv -c -t ascii//TRANSLIT | sed -E 's/[~^]+//g' | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z
}

ffmpeg_list() {
  printf "file '%s'\n" ./*.mp3 > input.txt 
}

prepend_each_line() {
  sed -i 's#^#"$1"#' "$2"
}

pastebinlong() {
    curl --silent https://oshi.at -F f=@$* \
    | grep DL \
    | cut -d " " -f 2 \
    | cb copy \
    && echo "link copied to clipboard"https://github.com/NeshHari/XMonad/tree/main/eww/.config/eww
}

thumbnailgen() {
    #don't forget to prerender your icon correctly
    #convert -size 256x256 -background "#242938" Bash-Dark.svg Bash-Dark.png
    convert -size 1280x720 xc:#242938 \
        -gravity center -draw "image over 0,0 256,256 $1" \
        -font iosevka-aile -fill white -pointsize 100 -gravity North -draw "text 0,100 \"$2\"" \
        -font iosevka-aile -fill white -pointsize 55 -gravity South -draw "text 0,100 \"$3\"" \
        out.png
    kitty +kitten icat out.png
    echo "(written to out.png)"
}

fman() {
	man -k . | fzf -q "$1" --prompt="man> " | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man 
}

encfile() {
	gpg --symmetric "$1"
}

decfile() {
	orig=${1%.gpg}
	[[ -f $orig ]] && { echo "$orig already exists"; return; }
	gpg --decrypt --output "$orig" "$1"
}

rss2mp3() {
	curl $1 | egrep -o "https?://.*mp3" | uniq | xargs -P 10 -I _ curl -OL _
}

emoji() {
  emojis=$(curl -sSL 'https://git.io/JXXO7')
  selected_emoji=$(printf "%s" $emojis|fzf --preview-window=hidden --cycle)
  [ -z "$selected_emoji" ] || printf "%s" "$selected_emoji"|cut -d" " -f1|xsel
} 

# pick an image with fzf and copy it to the clipboard
# ic = image copy
ic() {
  image=$(fd -t f -d 1 --extension png --extension jpg --extension jpeg --extension webm --extension gif|
    fzf -0 --cycle --preview="kitty +kitten icat --clear --transfer-mode file; \
  kitty +kitten icat --place "30x30@0x0" --scale-up --transfer-mode file {}")
  [ -z "$image" ] || xclip -selection clipboard -target image/png -i "$image"
}

meme() {
  (cd ~/Pictures/memes && ic) 
}

### Fzf functions

# pick and image with fzf and quickly share it
# is = image share
is() {
  image=$(fd -t f -d 1|fzf --cycle --preview="kitty +kitten icat --clear --transfer-mode file; \
  kitty +kitten icat --place "256x17@15x15" --scale-up --transfer-mode file {}")
  [ -z "$image" ] || printf $(curl -# "https://0x0.st" -F "file=@${image}")|xsel
}

cchar() {
  char=$(curl -s "https://you-zitsu.fandom.com/wiki/Category:Characters"|
    grep -B6 'class="category-page__member-thumbnail "'|
    sed -nE 's_.*href="([^"]*)".*_\1_p; s_.*data-src="([^"]*)".*_\1_p; s_.*alt="([^"]*)".*_\1_p'|
    sed -e 'N;N;s/\n/\t/g' -e 's_/width/[[:digit:]]\{1,3\}_/width/800_g' \
    -e 's_/height/[[:digit:]]\{1,3\}_/height/600_g'|
    fzf --reverse --with-nth 3.. --cycle --preview="kitty +kitten icat --clear --transfer-mode file; \
    kitty +kitten icat --place "256x17@10x10" --scale-up --transfer-mode file {2}"|cut -f1)
  [ -z "$char" ] && exit 1 || images=$(curl -sL "https://you-zitsu.fandom.com"$char|
    sed -nE 's_.*src="([^"]*)".*class="pi-image-thumbnail".*alt="([^"]*)".*_\1\t\2_p')
  [ $(printf "%s" "$images"|wc -l) -lt 2 ] && kitty +kitten icat $(printf "%s" "$images"|cut -f1) ||
  printf "%s" "$images"|fzf --with-nth 2.. --cycle --preview="kitty +kitten icat --clear --transfer-mode file; \
    kitty +kitten icat --place "256x17@10x10" --scale-up --transfer-mode file {1}" > /dev/null
}

# anime() {
  # ~/github/ani-cli/ani-cli
# }

open_with_nvim_filetype() {
  filetype=$(gum filter --indicator="→ " \
    --placeholder="Choose a filetype" --match.foreground="212" \
    --indicator.foreground="212" --text.foreground="360" \
    < ~/dev/sh_scripts/extensions.txt) || filetype=$*
  [ -z "$filetype" ] || FILE=$(rg --files -g "*.$filetype"|
    sort|fzf --cycle --reverse --height 95% -0)
  [[ -z "$FILE" ]] || $1 "$FILE"
}

open_with_nvim() {
  FILE=$(rg --files -g '!*.{gif,png,jp(e)g,mp4,mkv,webm,m4v,mov,MOV}'|fzf --reverse --height 95%)
  [[ -z $FILE ]] || $1 "$FILE"
}

# search for file and go into its directory
ji() {
   file=$(fzf -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# use fzf with tree preview to go into a directory
change_folder() {
  CHOSEN=$(fd '.' -d 1 -H -t d |fzf --cycle --height=95% --preview="exa -T {}" --reverse)
  [ -z $CHOSEN ] && return 0 || cd "$CHOSEN" && [ $(ls|wc -l) -le 60 ] && ls
}

# get cheat sheet for a command
chst() {
  [ -z "$*" ] && printf "Enter a command name: " && read -r cmd || cmd=$*
  curl -s cheat.sh/$cmd|bat --style=plain
}

# quickly access any alias or function i have
qa() { eval $( (alias && functions|sed -nE 's@^([^_].*)\(\).*@\1@p')|cut -d"=" -f1|fzf --reverse) }

# quickly copy a file or directory from ~/Downloads to current directory
cpd() {
  file=$(fd . "$HOME/Downloads" -t f|fzf -d"/" --with-nth -1.. --height=95%)
  [ ! -z "$file" ] && cp $file . && gum confirm "Delete the original file?" && rm $file || exit 1
}

# quickly edit config files
vc() {
  file=$(fd . "$HOME/.config" -t f|fzf -d"/" --with-nth -1.. --height=95%)
  [ -z "$file" ] || $EDITOR $file
}

# quickly edit nvim config stuff
nvc() {
  file=$(fd . "$HOME/.config/nvim" -t f -d 1|fzf -d"/" --with-nth -1.. --height=95%)
  [ -z "$file" ] || $EDITOR $file
}

# quickly edit zsh config stuff
zrg() {
  var=$(gum choose "zshrc" "functions" "aliases" "kitty" "xports" "bin" --item.foreground="360" --cursor="→ ")
  case $var in
    zshrc)
      $EDITOR $HOME/.zshrc ;;
    functions)
      $EDITOR $HOME/.oh-my-zsh/custom/functions.zsh ;;
    aliases)
      $EDITOR $HOME/.oh-my-zsh/custom/alias.zsh ;;
    kitty)
      $EDITOR $HOME/.config/kitty/kitty.conf ;;
    xports)
      $EDITOR $HOME/.oh-my-zsh/custom/xport.zsh ;;
    bin)
      $EDITOR $HOME/bin ;;
  esac
}

# quickly edit or run scripts from my scripts directory
se() {
  var=$(gum choose "edit" "run" --item.foreground="360" --cursor="→ ")
  script=$(find $HOME/bin -type f|sort|fzf --height=12 --cycle -d"/" --reverse)
  case $var in
    edit)
      printf "%s\n" "$script"|xargs nvim ;;
    run)
      sh $script ;;
  esac
}

#makes dir and cd's into it
mkcd() { mkdir -p -- "$@" && cd -- "$@"; }
filefndr() { find -type f -name "$1" -printf '%f\n' }

#interactive cd
function jj {
        cd "$(llama "$@")"
}
function ff {
        cd "$(f "$@")"
}
#interactive cd
function nnn_cd {
    if ! [ -z "$NNN_PIPE" ]; then
        printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" !&
    fi  
}
trap nnn_cd EXIT