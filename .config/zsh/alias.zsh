#-----------[Alias]---------------------#
alias hx="helix"
alias ff="firefox"
alias zz="zathura"
alias vim='nvim'
alias nv='nvim'
alias cat='bat -p'

alias wlc='wl-copy'
alias wlp='wl-paste'
alias db='distrobox'
alias zj='zellij'
alias yz='yazi'
alias pm='podman'

alias which-gpu='glxinfo|grep -E "OpenGL vendor|OpenGL renderer"'
alias history_most_used="history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head"
alias gsw='gamescope -f -W 1920 -H 1080 -- wine'
alias piper_play='piper-tts --model ~/ssd/pipertts/ivona-8-23/amy.onnx --output_raw | aplay -r 22050 -c 1 -f S16_LE -t raw'
alias aplay_tts='aplay -r 22050 -c 1 -f S16_LE -t raw'
alias ip_show="ip addr show | grep 'inet ' | cut -d ' ' -f 6 | cut -d / -f 1"


# Core utils + replacements
alias ls="eza --icons=always"
alias ll='eza -F -a -l --icons  --group-directories-first '
alias l='eza --long --grid --icons=always'
alias lsd="eza -l --group-directories-first"

alias e="eza --icons=always --color=always"
alias ee="eza --icons=always --color=always -a"
alias tree='eza -a -I .git --tree' # eza is an alternative to ls
alias du='du -sh'

alias mv="mv -i"
alias cp="cp -rvn"
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"

# Utility functions for Core utils
alias wget-pdf='wget -r -l 1 -nH -nd -np --ignore-case -A "*.pdf"'
alias zrc="hx ~/.zshrc && source ~/.zshrc"

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

alias chx="chmod +x"
alias fix-perms-dirs="find /home/sweet/bin -type d -exec chmod 774 {} +"
alias fix-perms-files="find /home/sweet/bin -type f -exec chmod 664 {} +"

# Git
alias gcl='git clone'
alias tsm="transmission-remote"

# fzf
alias fsh='fc -l -n -r 1 | sed -Ee "s/^[[:blank:]]+//" | uniq | fzf | tr -d \\n | wl-copy'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Internet
alias wget-links='wget -U "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --no-check-certificate "$1" -q -O - | grep -Po "(?<=href=\")[^^\"]*"'
alias wget-images='wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$1"'

# Locations
alias down="cd ~/Downloads"
alias pics="cd ~/Pictures"
alias vids="cd ~/Videos"
alias docs="cd ~/Documents"

#Pacman
alias pac="sudo pacman"
alias pacs="sudo pacman -S "
alias pacrm="sudo pacman -Rns"

# what package owns X file
alias pacmanowner="pacman -Qo"
alias pacd="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | bat -p -l yaml)' --bind 'esc:accept'" #lists all installed packages w/a double window TUI using fzf + info panel
alias pacc="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"

#handy shit
alias eip='echo $(curl -s http://ifconfig.me)'
alias zshxc="zsh -ixc : 2>&1 | grep"
alias fzawk='echo "" | fzf --print-query --preview 'echo "a\nb\nc\nd" | awk {q}''

# Programs
alias top="btop"
alias py='python'
alias share='printf $(curl -# "https://oshi.at" -F "f=@$(fd -t f -d 1|fzf)"|sed -nE "s_DL: (.*)_\1_p")|xsel' #share file to file share site

# Yt-dlp
alias ytdl='yt-dlp --embed-thumbnail --embed-metadata'
alias yta="yt-dlp --embed-thumbnail --embed-metadata -x"
alias ytd="yt-dlp --embed-thumbnail --embed-metadata -x -o './%(title)s-%(id)s.%(ext)s'"

# System
alias psa="ps -e | grep -i"
alias disks="lsblk --nodes --output NAME,MODEL,SIZE"
alias parts="lsblk --output NAME,LABEL,FSTYPE,MOUNTPOINTS,SIZE,MODEL"

alias fonts='fc-list --format="%{family[0]}\n" | sort|uniq| fzf'
alias paths='sed "s/:/\n/g" <<< $PATH'
alias fpaths='sed "s/:/\n/g" <<< $FPATH'

# Kitty
alias kittydiff="git difftool --no-symlinks --dir-diff"

# Curl
alias curluser='curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"'
