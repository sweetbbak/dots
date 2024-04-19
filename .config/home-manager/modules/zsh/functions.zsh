## some handy functions I've written or collected
CLIPBOARD=wl-copy

# man() {
#     man "${@}" | bat -l man -p
# }
#
mps() {
    mpv --vo=kitty --vo-kitty-use-shm=yes "ytdl://ytsearch: $*"
}
mx() {
    manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview="manix '{}'" | xargs manix
}

nr() {
    pkg="$1"
    nix-shell -p "${pkg}" --run "${*}"
}

vv() {
  # Assumes all configs exist in directories named ~/.config/nvim-*
  local config=$(fd --max-depth 1 --glob 'nvim*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
 
  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return
 
  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) nvim $@
}

function zr () { zellij run --name "$*" -- zsh -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
function ze () { zellij edit "$*";}
function zef () { zellij edit --floating "$*";}

function gocd () { cd $(go list -f '{{.Dir}}' $1) }

function lx() {
    # makes it easy to list files and dirs and then also see their contents
    # without having to ctrl+<- and change the command name to (cat|icat|xxd)
    ls "$@" && ~/scripts/lessfilter.sh "$@"
}

function contize() {
    echo -e "\x1b[32m[WARN]\x1b[0m your home directory [$HOME] will NOT be read-only. It is mounted in a container and is accessible from insde"
    podman run -it --rm               \
        --security-opt label=disable  \
        --userns=keep-id              \
        -v "$HOME:$HOME" -v /tmp:/tmp \
        -w "$PWD"                     \
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
        *) realpath "${1}" | tr -d \\n | wl-copy && echo "copied filepath" ;;
    esac
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

function nvim-replace() {
    if [ $# -lt 2 ]
    then
        echo "Recursive, interactive text replacement"
        echo "Usage: replace text replacement"
        return
    fi

    nvim -u NONE -c ":execute ':argdo %s/$1/$2/gc | update' | :q" $(rg $1 -l)
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

# quickly copy a file or directory from ~/Downloads to current directory
function cpd() {
  file=$(fd . "$HOME/Downloads" -t f| fzf -d"/" --with-nth -1.. --reverse --height=95%)
  [ ! -z "$file" ] && cp ${file} .
}

function emoji() {
  emojis=$(curl -sSL 'https://git.io/JXXO7')
  selected_emoji=$(printf "%s" $emojis|fzf --preview-window=hidden --cycle)
  [ -z "$selected_emoji" ] || printf "%s" "$selected_emoji"|cut -d" " -f1|wl-copy
} 

function snips() {
  "$EDITOR" /home/sweet/.snippets
}


function d() {
  exe="$(which $1)"
  if file "${exe}" | grep -i ASCII &>/dev/null; then
      $EDITOR "${exe}"
  else
      file "${exe}"
      echo "file is not ascii"
  fi
}

function wget-imgs() {
  wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$@"
}

## Resize images
function 75%() { mogrify -resize '75%X75%' "$@" ; }
function 50%() { mogrify -resize '50%X50%' "$@" ; }
function 25%() { mogrify -resize '25%X25%' "$@" ; }

function ffmpeg_list() {
  printf "file '%s'\n" ./*.mp3 > input.txt 
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

function encfile() {
	gpg --symmetric "$1"
}

function decfile() {
	orig=${1%.gpg}
	[[ -f $orig ]] && { echo "$orig already exists"; return; }
	gpg --decrypt --output "$orig" "$1"
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

#makes dir and cd's into it
function mkcd() { mkdir -p -- "$@" && builtin cd -- "$@"; }

