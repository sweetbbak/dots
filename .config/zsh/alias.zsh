#-----------[Alias]---------------------#
alias hx="helix"
alias zz="zathura"
alias nsxiv="nsxiv -a"
alias v='nvim'
alias nv='nvim'
alias nb="newsboat"

# Core utils + replacements
alias ls="exa --icons"
alias ll='exa -Fal'
alias l='exa --long --grid'
alias lsd="exa -l --group-directories-first"

alias e="exa --icons --color=always"
alias ee="exa --icons --color=always -a"
alias tree='exa -a -I .git --tree' # exa is an alternative to ls

alias mv="mv -i"
alias cp="cp -rv"
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias rd='rm -rI "$(exa -D| fzf --height=20% --preview="exa -l {}")"'
alias cxx='chmod +x "$(rg --files -g "*.sh"|fzf -1 --height=20% --preview-window=hidden)"'

# Utility functions for Core utils
alias ag="alias | grep "
alias zrc="hx ~/.zshrc && source ~/.zshrc"

alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'
alias j.='cd -'

alias hg="history 1 | grep"
alias pwz='sudo !!'
alias kitconfig='nvim ~/.config/kitty/kitty.conf'
alias chx="chmod +x"
# alias fix-perms="find /home/sweet/bin -type d -exec chmod 774 {} +"
# alias fix-perms="find /home/sweet/bin -type f -exec chmod 664 {} +"
alias awtt="awesome-test"
alias b='cd $(dirs -v|fzf)'

# Git
alias gcl='git clone'

# OCR
# alias ocr='scrot -s -o -f '/any/path/OCR.png' -e 'tesseract -l jpn $f stdout | xclip -selection clipboard && rm $f''
alias nv='neovidecloseterminal'

# fzf
alias fsh='fc -l -n -r 1 | sed -Ee "s/^[[:blank:]]+//" | uniq | fzf | tr -d \\n | xclip -selection c'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias fzf-preview='printf "fzf --with-nth 2.. --cycle --preview=\"kitty +kitten icat --clear --transfer-mode file;\
  kitty +kitten icat --place "190x12@10x10" --scale-up --transfer-mode file {1}\""|xsel'

# Internet
alias wget-links='wget -U "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --no-check-certificate "$1" -q -O - | grep -Po "(?<=href=\")[^^\"]*"'
alias wget-images='wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg -H "$1"'

# Etc.
alias fzr='\ls -vR ~/bin | fzf --reverse --bind "enter:execute({})+accept"'
alias anifzf='alacritty --class "kitty-fzf" -e bash -c "ani-cli"'
alias pass-to-fzf='alacritty --class "kitty-fzf" -e bash -c "fzf $* < /proc/$$/fd/0 > /proc/$$/fd/1"'
alias vg='nvim $(gum filter)'
# Locations
alias t7='cd /run/media/sweet/T7'
alias windows='cd /run/media/sweet/623C48973C48685D/Users/User'
alias drives='cd /run/media/sweet'
alias ddrv='cd /run/media/sweet/Hard\ Drive'
alias down="cd ~/Downloads"
alias pics="cd ~/Pictures"
alias vids="cd ~/Videos"

#Pacman
alias pac="sudo pacman"
alias pacs="sudo pacman -S "
alias pacrm="sudo pacman -R"
alias pacup="sudo pacman -Syu"
alias pacq="pacman -Q | grep"
alias pacls="pacman -Q"
alias pacd="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'" #lists all installed packages w/a double window TUI using fzf + info panel
alias pacc="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"

#handy shit
alias eip='echo $(curl -s http://ifconfig.me)'
alias hlp='find ./ -printf "%f\n" | gum filter'
alias px2ansi='python ~/github/px2ansi/px2ansi.py'
alias icat="kitty +kitten icat"
alias zshxc="zsh -ixc : 2>&1 | grep"
alias fzman="echo '' | fzf --preview 'man {q}'"
# alias fzawk='echo "" | fzf --print-query --preview 'echo "a\nb\nc\nd" | awk {q}''

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
alias ytdl='yt-dlp'
alias yta="yt-dlp --embed-thumbnail -f 'bestaudio/best' -f 'm4a'"
alias ytd="yt-dlp -f 'bestvideo[height<=?1080]+bestaudio/best' -f 'mp4'"
alias ytdd="yt-dlp -f 'bestvideo[height<=?720]+bestaudio/best' -f 'mp4'"
alias ytddd="yt-dlp -f 'bestvideo[height<=?480]+bestaudio/best' -f 'mp4'"
alias download="yt-dlp -x --audio-format mp3"

# Media

# System
alias psa="ps -e | grep -i"
alias sudosys="sudo systemctl"
alias envfz="env | fzf"
alias disks="lsblk --nodes --output NAME,MODEL,SIZE"
alias parts="lsblk --output NAME,LABEL,FSTYPE,MOUNTPOINTS,SIZE,MODEL"

alias fonts='fc-list --format="%{family[0]}\n" | sort|uniq| fzf'
alias paths='sed "s/:/\n/g" <<< $PATH'
alias finddir="find . -type d -name"
alias findfile="find . -type f -name"

alias fff="fd -d 2 | fzf --preview 'bat --color=always --style=numbers {}'"

# Kitty
alias pix="pixcat resize -w 64 -h 32 -W 512 -H 256 --align center --relative-x -2"
alias kittydiff="git difftool --no-symlinks --dir-diff"

# Curl
alias curluser='curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"'
alias fzls="find . -maxdepth 1 2> /dev/null |sort -h | sed '1d; s|^\./||' | fzf"
alias fzliss="fd . | fzf --preview 'bat --color=always --style=numbers {}'"

# nvim stuff
alias nvff="open_with_nvim_filetype nvim"
alias nif="open_with_nvim neovide"
alias niff="open_with_nvim_filetype neovide"
