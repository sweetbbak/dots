#-----------[Alias]---------------------#
alias hx="helix"
alias hx.="helix ."
alias ff="firefox"
alias zz="zathura"
alias nsxiv="nsxiv -a"
alias v='nvim'
alias nv='nvim'
alias cat='bat -p'
alias gsw='gamescope -f -W 1920 -H 1080 -- wine'
alias piper_play='piper-tts --model ~/ssd/pipertts/ivona-8-23/amy.onnx --output_raw | aplay -r 22050 -c 1 -f S16_LE -t raw'
alias aplay_tts='aplay -r 22050 -c 1 -f S16_LE -t raw'
alias ip_show="ip addr show | grep 'inet ' | cut -d ' ' -f 6 | cut -d / -f 1"

alias wlc='wl-copy'
alias wlp='wl-paste'
alias db='distrobox'
alias history_most_used="history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head"

# Core utils + replacements
alias ls="eza --icons=always"
alias ll='eza -Fal --icons  --group-directories-first '
alias l='eza --long --grid --icons=always'
alias lsd="eza -l --group-directories-first"

alias e="eza --icons=always --color=always"
alias ee="eza --icons=always --color=always -a"
alias tree='eza -a -I .git --tree' # eza is an alternative to ls
alias du='du -sh'

alias mv="mv -i"
alias cp="cp -rvn"
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias rd='rm -rI "$(eza -D| fzf --height=20% --preview="eza -l {}")"'
alias cxx='chmod +x "$(rg --files -g "*.sh"|fzf -1 --height=20% --preview-window=hidden)"'

# Utility functions for Core utils
alias srs="fd . $path | fzf --height=33% --preview='bat {}' | xargs bash -c"
alias wget-pdf='wget -r -l 1 -nH -nd -np --ignore-case -A "*.pdf"'

alias ag="alias | grep "
alias zrc="hx ~/.zshrc && source ~/.zshrc"
alias z='zoxide'

# GO
alias gmi='go mod init'
alias gmt='go mod tidy'
alias gb='go build'

# rsync
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'
alias j.='cd -'

alias hg="history 1 | grep"
alias pwz='sudo !!'
alias chx="chmod +x"
alias fix-perms-dirs="find /home/sweet/bin -type d -exec chmod 774 {} +"
alias fix-perms-files="find /home/sweet/bin -type f -exec chmod 664 {} +"

# Git
alias gcl='git clone'
alias tsm="transmission-remote"

# OCR
# alias ocr='scrot -s -o -f '/any/path/OCR.png' -e 'tesseract -l jpn $f stdout | xclip -selection clipboard && rm $f''

# fzf
alias fsh='fc -l -n -r 1 | sed -Ee "s/^[[:blank:]]+//" | uniq | fzf | tr -d \\n | wl-copy'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# alias fzf-preview='printf "fzf --with-nth 2.. --cycle --preview=\"kitty +kitten icat --clear --transfer-mode file;\
#   kitty +kitten icat --place "190x12@10x10" --scale-up --transfer-mode file {1}\""|xsel'

# Internet
alias wget-links='wget -U "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --no-check-certificate "$1" -q -O - | grep -Po "(?<=href=\")[^^\"]*"'
alias wget-images='wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$1"'

# Etc.
# alias fzr='\ls -vR ~/bin | fzf --reverse --bind "enter:execute({})+accept"'
# alias anifzf='alacritty --class "kitty-fzf" -e bash -c "ani-cli"'
# alias pass-to-fzf='alacritty --class "kitty-fzf" -e bash -c "fzf $* < /proc/$$/fd/0 > /proc/$$/fd/1"'
alias hxx='hx $(gum filter)'
# Locations
alias t7='cd /run/media/sweet/T7'
# alias drives='cd /run/media/sweet'
alias ssd='cd ~/ssd'
alias vmshare='cd ~/ssd/vmshare'
alias hdd='cd ~/hdd'
alias hd2='cd ~/hd2'
alias down="cd ~/Downloads"
alias pics="cd ~/Pictures"
alias vids="cd ~/Videos"
alias docs="cd ~/Documents"

#Pacman
alias pac="sudo pacman"
alias pacs="sudo pacman -S "
alias pacrm="sudo pacman -R"
alias pacup="sudo pacman -Syu"
# what package owns X file
alias pac-who="pacman -Qo"
alias pacq="pacman -Q | grep"
alias pacls="pacman -Q"
alias pacd="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | bat -p -l yaml)' --bind 'esc:accept'" #lists all installed packages w/a double window TUI using fzf + info panel
alias pacc="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"

#handy shit
alias eip='echo $(curl -s http://ifconfig.me)'
alias icat="kitty +kitten icat"
alias zshxc="zsh -ixc : 2>&1 | grep"
alias fzman="echo '' | fzf --preview 'man {q}'"
alias fzawk='echo "" | fzf --print-query --preview 'echo "a\nb\nc\nd" | awk {q}''
# alias px2ansi='python ~/github/px2ansi/px2ansi.py'

# Programs
alias top="btop"
alias lsall='find ./ -printf "%f\n"'
alias py='python'
# alias n='nnn -de'
alias share='printf $(curl -# "https://oshi.at" -F "f=@$(fd -t f -d 1|fzf)"|sed -nE "s_DL: (.*)_\1_p")|xsel' #share file to file share site
alias ximg='xclip -selection clipboard -target image/png -i'
alias xout='xclip -se c -t image/png -o >'
alias fmpv='mpv "$(fzf)"'

# Yt-dlp
alias ytdl='yt-dlp --embed-thumbnail'
alias yta="yt-dlp --embed-thumbnail --embed-metadata -x"
alias ytd="yt-dlp --embed-thumbnail --embed-metadata -x -o './%(title)s-%(id)s.%(ext)s'"
# alias ytd="yt-dlp -f 'bestvideo[height<=?1080]+bestaudio/best' -f 'mp4'"
# alias ytdd="yt-dlp -f 'bestvideo[height<=?720]+bestaudio/best' -f 'mp4'"
# alias ytddd="yt-dlp -f 'bestvideo[height<=?480]+bestaudio/best' -f 'mp4'"
alias download="yt-dlp -x --audio-format --embed-thumbnail --embed-metadata mp3"

# Media

# System
alias psa="ps -e | grep -i"
alias sudosys="sudo systemctl"
alias envfz="env | fzf"
alias disks="lsblk --nodes --output NAME,MODEL,SIZE"
alias parts="lsblk --output NAME,LABEL,FSTYPE,MOUNTPOINTS,SIZE,MODEL"

alias fonts='fc-list --format="%{family[0]}\n" | sort|uniq| fzf'
alias paths='sed "s/:/\n/g" <<< $PATH'
alias fpaths='sed "s/:/\n/g" <<< $FPATH'
# alias finddir="find . -type d -name"
# alias findfile="find . -type f -name"

# alias fff="fd -d 2 | fzf --preview 'bat --color=always --style=numbers {}'"

# Kitty
alias pix="pixcat resize -w 64 -h 32 -W 512 -H 256 --align center --relative-x -2"
alias kittydiff="git difftool --no-symlinks --dir-diff"

# Curl
alias curluser='curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"'
# alias fzls="find . -maxdepth 1 2> /dev/null |sort -h | sed '1d; s|^\./||' | fzf"
# alias fzliss="fd . | fzf --preview 'bat --color=always --style=numbers {}'"

# nvim stuff
alias nvff="open_with_nvim_filetype nvim"
alias nif="open_with_nvim neovide"
alias niff="open_with_nvim_filetype neovide"
