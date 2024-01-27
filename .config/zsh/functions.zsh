## some handy functions I've written or collected
CLIPBOARD=wl-copy

function zr () { zellij run --name "$*" -- zsh -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
function ze () { zellij edit "$*";}
function zef () { zellij edit --floating "$*";}

function gocd () { cd `go list -f '{{.Dir}}' $1` }

function lx() {
    # makes it easy to list files and dirs and then also see their contents
    # without having to ctrl+<- and change the command name to (cat|icat|xxd)
    ls "$@" && ~/scripts/lessfilter.sh "$@"
}

function contize() {
    echo -e "\x1b[32m[WARN]\x1b[0m your home directory [$HOME] will NOT be read-only. It is mounted in a container and is accessible from insde"
    podman run -it --rm \
        --security-opt label=disable \
        --userns=keep-id \
        -v "$HOME:$HOME" -v /tmp:/tmp \
        -w "$PWD" \
        "$@"
}

function gg() {
    cd "$(fd . "${1:-$HOME}" --hidden --max-depth 5 -t d -j20 -HI ".git" | sed 's|/.git$||' | fzf --preview 'eza -T {}')"
}

function process_with_most_memory() {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
}

function list_open_ports() {
    netstat -tuln
}

function find_listening_ports() {
    if [ -z "$1" ]; then echo "Usage: find_listening_ports <pid>"
    else ss -tulnp | grep "$1"
    fi
}

function lman() {
  man "${1}" | less -R --use-color -Dd+r -Du+b | bat -l man -p
}

# show #1e1e1e will display a black box - color preview
function show_color() {
    perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@"
}

# bookmark directory
# bm () {
#     # usage: bm bookmark (bookmarks current directory)
#     [ -f ~/.config/to ] || touch ~/.config/to
#     if grep -E $PWD'$' ~/.config/to
#     then
#         echo ...already exists
#     else
#         echo "$PWD" >> ~/.config/to
#     fi
# }

# # pair to bookmark - jump to dir
# to () {
#     q=" $*"
#     q=${q// -/ !}
#     # allows typing "to foo -bar", which becomes "foo !bar" in the fzf query
#     cd "$(fzf -1 +m -q "$q" < ~/.config/to)"
# }

function include_raw_exe() {
    xxd --include "${@}" | $CLIPBOARD
}

function bytes() {
    [ -f "${1}"  ] && {
    xxd -b "${1}" | sed -r "s/\d32{3,}.*//g" | sed "s/.*://" | sed "s/\d32//g" 
    exit 0
    }
    echo -e 'bytes <file>\ndump bytes of a file'
}

function getip() {
    ip -c -o a | awk '{print $2,$4}' | column -t
    curl -s "https://ipapi.co/8.8.8.8/yaml" | awk -F': ' '
	/ip:/ { ip=$2 }
	/asn:/{ asn=$2 }
	/city:/{ city=$2;}
	/country_name:/ { country=$2}
	/org:/{ printf "%s, %s, %s, %s, %s\n", ip, asn, $2, city, country; }'
}

function ya() {
	tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# copy the full path of a file
function rp() {
    case "$1" in
        -h|--help) echo "rp <file> - copies files full path" ;;
        *) realpath "${1}" | sed 's/\n//g' |wl-copy && echo "copied filepath" ;;
    esac
}

# termcap
# ks       make the keypad send commands
# ke       make the keypad send digits
# vb       emit visual bell
# mb       start blink
# md       start bold
# me       turn off bold, blink and underline
# so       start standout (reverse video)
# se       stop standout
# us       start underline
# ue       stop underline

function fzcd() {
    dir="$(fd -d1 -td | fzf --preview='exa {}')"
    dir=$(realpath "$dir")
    [ -d "$dir" ] && cd "${dir}" || echo "error"
}

# bat help, get highlighted help text in a pager
alias bathelp='bat --plain --language=help'
function help() {
    "$@" --help 2>&1 | bathelp
}

# git clone and cd into git repo. $_ is a special variable and basename
# gets the last section after the '/'
function gc() {
   git clone "$1" && cd "$(basename "$_" .git)"
}

function vreplace() {
    if [ $# -lt 2 ]
    then
        echo "Recursive, interactive text replacement"
        echo "Usage: replace text replacement"
        return
    fi

    vim -u NONE -c ":execute ':argdo %s/$1/$2/gc | update' | :q" $(rg $1 -l)
}

# like rfv but with ripgrep-all for pdf, doc, sqlite, jpg, movie subs etc...
function rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

# print an alias to the command line to edit and run
function funcs() {
  print -z $(functions "$@")
}

function ali() {
  print -z $(alias "$@")
}

# quickly copy a file or directory from ~/Downloads to current directory
function cpd() {
  file=$(fd . "$HOME/Downloads" -t f| fzf -d"/" --with-nth -1.. --reverse --height=95%)
  [ ! -z "$file" ] && cp ${file} .
}

# use fzf with tree preview to go into a directory
function change_folder() {
  CHOSEN=$(fd '.' -d 4 -H -t d $DIR|fzf --cycle --height=95% --preview="exa -T {}" --reverse)
  [ -z $CHOSEN ] && return 0 || cd "$CHOSEN" && [ $(ls|wc -l) -le 60 ] && ls
}

function open_with_mpv() {
  VIDEO_PATH=$(rg --files -g '!anime/' -g '!for_editing/' -g '*.{mp4,mkv,webm,m4v}' | fzf --cycle)
    [[ -z $VIDEO_PATH ]] || (mpv "$VIDEO_PATH")
}

# function animes(){
#   animdl stream "$1" -r "$2"
# }

# animeg() {
#   animdl grab "$1" -r "$2" --index 1|sed -nE 's|.*stream_url": "(.*)".*|\1|p'|wl-copy
# }

function configs () {
  local search_dir=~/.config
  local preview_cmd="exa -lah --sort=type --icons --no-permissions --no-filesize --no-time --no-user $search_dir/{}"

  local target_dir=$(fd . $search_dir --exact-depth=1 --type d --exec printf '{/}\0' | fzf --preview $preview_cmd --exit-0 --read0)

  if [ -n $target_dir ]; then
    cd $search_dir/$target_dir
    exa -lah --group-directories-first --icons
  fi
}

### Fzf functions

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
### Other

function emoji() {
  emojis=$(curl -sSL 'https://git.io/JXXO7')
  selected_emoji=$(printf "%s" $emojis|fzf --preview-window=hidden --cycle)
  [ -z "$selected_emoji" ] || printf "%s" "$selected_emoji"|cut -d" " -f1|wl-copy
} 

function addpkg(){
    paru -Ss "$*" | sed -nE 's|^[a-z]*/([^ ]*).*|\1|p' | fzf --preview 'paru -Si {} | bat --language=yaml --color=always -pp' --preview-window right:65%:wrap -m | paru -S -
}

function rmpkg(){
    paru -Qq | fzf --preview 'paru -Si {} | bat --language=yaml --color=always -pp' --preview-window right:65%:wrap -m | paru -Rcns -
}

# fuzzy-find a file and cd to its directory
function cdff() {
  local seld="$(fff "$@")"
  [ -n "$seld" ] && pushd "$(dirname "$seld")"
}

# fuzzy-find in history and paste to command-line
function fzh() {
  local selh="$(history -1 0 | fzf --query="$@" --ansi --no-sort -m --height=50% --min-height=25 -n 2.. | awk '{ sub(/^[ ]*[^ ]*[ ]*/, ""); sub(/[ ]*$/, ""); print }')"
  [ -n "$selh" ] && print -z -- ${selh}
}

# list env variables
function list_env() {
	local var
	var=$(printenv | cut -d= -f1 | fzf --prompt 'env:' --preview='printenv {}') \
		&& echo "$var=$(printenv "$var")" \
		&& unset var
}

# fzf browse files
function find_files() {
	IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0 --prompt 'files:'))
	[[ -n "$files" ]] && ${EDITOR} "${files[@]}"
}

# list env variables
function list_env() {
	local var
	var=$(printenv | cut -d= -f1 | fzf --prompt 'env:' --preview='printenv {}') \
		&& echo "$var=$(printenv "$var")" \
		&& unset var
}

function fcd() {
  # use print -z -- $(func) to just add to command line
	local dir
	dir=$(fd -IH -t d 2> /dev/null | fzf --prompt 'folders:' +m --preview-window='right:50%:nohidden:wrap' --preview='exa --tree --level=2 {}') && cd "$dir"
}

function snips() {
  "$EDITOR" /home/sweet/.snippets
}

function fzx() {
  print -z -- $(fd -t d | fzf)
}

function fzs() {
    local sels=( "${(@f)$(fd --color=always . "${@:2}" | fzf -m --height=25% --reverse --ansi)}" )
    [ -n "$sels" ] && print -z -- "$1 ${sels[@]:q:q}"
}

function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )
    
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

function anima() {
  animdl grab "$1" -r "$2" --index 1 | sed -nE 's|.*stream_url": "(.*)".*|\1|p'| cb copy
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
function fo() {
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

function d() {
  exe="$(which $1)"
  file "${exe}" | grep -i ASCII && hx "${exe}"
  file "${exe}"
  realpath "${exe}"
}

# ocr() {
#   scrot -s -o -f '/home/sweet/Pictures/OCR.png' -e 'tesseract -l jpn $f stdout | xclip -selection clipboard && rm $f'
# }

function bkr() {
  (nohup "$@" &>/dev/null & disown)
}

# riz(){
  # wmctrl -r :ACTIVE: -e "$(slop -f 0,%x,%y,%w,%h)"
# }

function get-xwindows() {
  wmctrl -lx | grep -E "$1" | grep -oE "[0-9a-z]{10}"
}

function get_domain(){
	echo "$1" | sed -E 's#^https?://(www\.)?##; s#/.*##'
}

function wget-imgs() {
  wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$@"
}

# Imagemagick
## Resize images
function 75%() { mogrify -resize '75%X75%' "$@" ; }
function 50%() { mogrify -resize '50%X50%' "$@" ; }
function 25%() { mogrify -resize '25%X25%' "$@" ; }
## Scan folder for images of a certain ratio

function parurm() {
  SELECTED_PKGS="$(paru -Qsq | fzf --header='Remove packages' -m --height 100% --preview 'paru -Si {1}')"
  if [ -n "$SELECTED_PKGS" ]; then
    paru -Rns $(echo $SELECTED_PKGS)
  fi
}

#short for pathfinder :)
function pthf() {
  echo $PATH | sed 's/:/\n/g' | fzf
}

# ani-cli() {
#   ~/github/ani-cli/ani-cli
# }

function icons() {
  selection=$(cat "$HOME"/.config/rofi/icons-list.txt | rofi -dmenu -i -markup-rows -p "" -columns 6 -width 100 -location 1 -lines 20 -bw 2 -yoffset -2 | cut -d\' -f2) 
  cat "$selection" | wl-copy
}

function get-volume() {
  awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master)
}

function slugify () {
    echo "$1" | iconv -c -t ascii//TRANSLIT | sed -E 's/[~^]+//g' | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z
}

function ffmpeg_list() {
  printf "file '%s'\n" ./*.mp3 > input.txt 
}

function prepend_each_line() {
  sed -i 's#^#"$1"#' "$2"
}

function pastebinlong() {
    curl --silent https://oshi.at -F f=@$* \
    | grep DL \
    | cut -d " " -f 2 \
    | cb copy \
    && echo "link copied to clipboard"
}

function thumbnailgen() {
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

function fman() {
	man -k . | fzf -q "$1" --prompt="man> " | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man 
}

function encfile() {
	gpg --symmetric "$1"
}

function decfile() {
	orig=${1%.gpg}
	[[ -f $orig ]] && { echo "$orig already exists"; return; }
	gpg --decrypt --output "$orig" "$1"
}

function rss2mp3() {
	curl $1 | egrep -o "https?://.*mp3" | uniq | xargs -P 10 -I _ curl -OL _
}

# pick an image with fzf and copy it to the clipboard
# ic = image copy
function ic() {
  image=$(fd . "${1:-/home/sweet/Pictures}" -tf -d2 --extension png --extension jpg --extension jpeg --extension webm --extension gif |\
  fzf --cycle --preview='kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}')
  [ -z "$image" ] || $CLIPBOARD "$image"
}

function meme() {
  img=$(cd ~/Pictures/memes && fzf --preview='
    kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}
  ')
  [ -z "${img}" ] && exit 0
  $CLIPBOARD "${img}"
}

# search for file and go into its directory
function ji() {
   file=$(fzf -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# get cheat sheet for a command
function chst() {
  [ -z "$*" ] && printf "Enter a command name: " && read -r cmd || cmd=$*
  curl -s cheat.sh/$cmd|bat --style=plain
}

# quickly access any alias or function i have
function qa() { eval $( (alias && functions|sed -nE 's@^([^_].*)\(\).*@\1@p')|cut -d"=" -f1|fzf --reverse) }

# quickly edit zsh config stuff
function zzz() {
  var=$(printf "%s\n" "zshrc" "functions" "aliases" "zshenv" | fzf --bind='tab:toggle-down' --reverse --height=15% --cycle --preview='
            file={}
            case {} in
                zshrc) bat ~/.zshrc ;;
                zshenv) bat ~/.zshenv ;;
                functions) bat ~/.config/zsh/functions.zsh ;;
                aliases) bat ~/.config/zsh/alias.zsh ;;
                *) echo "lol :p" ;;
            esac
        ')

  case $var in
    zshrc)
      $EDITOR $HOME/.zshrc && exec zsh ;;
    functions)
      $EDITOR $HOME/.config/zsh/functions.zsh ; exec zsh ;;
    aliases)
      $EDITOR $HOME/.config/zsh/alias.zsh ; exec zsh ;;
    zshenv)
      $EDITOR $HOME/.zshenv ; exec zsh ;;
    *) exit 0 ;;
  esac
  zsh
}

#makes dir and cd's into it
function mkcd() { mkdir -p -- "$@" && cd -- "$@"; }

#interactive cd
function jj {
    # command -v llama -h &>/dev/null || exit
    cd "$(llama "$@")"
}
