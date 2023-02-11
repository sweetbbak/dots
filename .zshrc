export PATH=$PATH:~/.local/bin:~/bin:~/.cargo/bin:~/go/bin:~/dev/bin:~/.luarocks/bin:"$PATH"
export PATH=$PATH:~/scripts/bin:~/src/bin:"$PATH"
export EDITOR='helix'
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
export VISUAL='code'
export DIFFPROG="nvim -d"
PATH=$PATH$( find $HOME/bin/ -type d -printf ":%p" ):$PATH
# PATH=$PATH$( find $HOME/scripts/ -type d -printf ":%p" ):$PATH
export PATH=$HOME/.config/rofi/scripts:$PATH

# export BAT_THEME="Catppuccin-mocha"
. "$HOME/.cache/wal/colors.sh"

ZSH_THEME="cummies"
DISABLE_AUTO_UPDATE="true"

bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey ' ' magic-space

#zsh plugins
plugins=(zsh-syntax-highlighting zsh-autosuggestions archlinux colored-man-pages)

# History configurations
setopt autocd
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history         # share command history data

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

export MANPATH="/usr/local/man:$MANPATH"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

#-----------[NNN]---------------------#
export NNN_OPTS="H" # 'H' shows the hidden files. Same as option -H (so 'nnn -deH')
export LC_COLLATE="C" # hidden files on top
export NNN_FIFO=/tmp/nnn.fifo # temporary buffer for the previews
export NNN_PLUG='o:fzopen;e:-!sudo -E nvim $nnn*;h:-!hx $nnn*;p:preview-tui;x:!chmod +x $nnn;m:!mpv $nnn'
export SPLIT='v' # to split Kitty vertically

NNN_TMPFILE='/tmp/.lastd'
BLK="04" CHR="04" DIR="04" EXE="00" REG="00" HARDLINK="00" SYMLINK="06" MISSING="00" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="02"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

# export FZF_DEFAULT_OPTS="
#   --color=fg:#ff007c,bg:-1,hl:#03d8f3 --color=fg+:#00ffc8,bg+:,hl+:#03d8f3 
#   --color=info:#ff0055,prompt:#fcee0c,pointer:#ffb800 --color=marker:#00ffc8,spinner:#ffb800,header:#fcee0c
#   --reverse --border=rounded
# "
# Custom Pink & Black theme
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#ff5f87,hl:#008ec4 --color=fg+:#d75f87,bg+:#4e4e4e,hl+:#5fd7ff --color=info:#afaf87,prompt:#c30771,pointer:#af5fff --color=marker:#c30771,spinner:#af5fff,header:#a790d5'
# umask 022 to set default permissions
# export PATH="$PATH:/home/sweet/.bin"
