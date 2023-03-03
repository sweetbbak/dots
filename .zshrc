export PATH=$PATH:~/.local/bin:~/bin:~/.cargo/bin:~/go/bin:~/dev/bin:~/.luarocks/bin::~/scripts:~/scripts/fzf-bin:~/src:~/node_modules/.bin:~/apps:~/apps/blender340:
export EDITOR='helix'
# export STARSHIP_CONFIG=~/example/non/default/path/starship.toml

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
export HISTDUP=erase

export VISUAL='lapce'
export PAGER='less -R'
export DIFFPROG="nvim -d"
export DOTBARE_DIR="$HOME/.dotfiles"
export DOTBARE_TREE="$HOME"
export DOTBARE_PREVIEW="bat -n {}"
export DOTBARE_BACKUP="/run/media/sweet/Hard Drive/linux-backups/dotbare"
PATH=$PATH$( find $HOME/bin/ -type d -printf ":%p" )
# PATH=$PATH$( find $HOME/scripts/ -type d -printf ":%p" ):$PATH
# export PATH=$HOME/.config/rofi/scripts:$PATH

# export BAT_THEME="Catppuccin-mocha"
source "$HOME/.cache/wal/colors.sh"

# fzf tab
source "$HOME/github/fzf-tab/fzf-tab.plugin.zsh"
source "$HOME/.config/zsh/fzf-history/zsh-fzf-history-search.zsh"
zstyle ':autocomplete:*' default-context history-incremental-search-backward
# fzf history
# source ~/github/zsh-autocomp/zsh-autocomplete.plugin.zsh

# Starship
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey ' ' magic-space

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
# zstyle ':completion:*' completer _extensions _complete _approximate
# zstyle ':completion:*' menu select
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# zstyle ':completion:*:*:*:*:*' menu select
# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# zstyle ':completion:*' rehash true
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd' #pletion of files and dirnames
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# zstyle ':completion:*' fzf-search-display true
# bindkey '\e[A' history-beginning-search-backward
# bindkey '\e[B' history-beginning-search-forward

# History configurations
setopt autocd
# setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_ignore_dups       # ignore duplicated commands history list
# setopt hist_ignore_space      # ignore commands that start with space
# setopt hist_verify            # show command with history expansion to user before running it
setopt share_history         # share command history data
# setopt appendhistory
setopt sharehistory
# setopt incappendhistory
# setopt hist_ignore_all_dups
# setopt hist_save_no_dups
# setopt hist_ignore_dups
# setopt hist_find_no_dups
setopt interactivecomments # allow comments in interactive mode
# setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
# setopt nonomatch           # hide error message if there is no match for the pattern
# setopt notify              # report the status of background jobs immediately
# setopt numericglobsort     # sort filenames numerically when it makes sense
# setopt promptsubst         # enable command substitution in prompt

setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
# bindkey '\e[1;5A' history-beginning-search-backward
# bindkey '\e[1;5B' history-beginning-search-forward

# THIS IS IT LOL THIS WAS WHAT I WAS LOOKING FOR HAHAHA
# match the command in history and search ie: wget ... + up key searches for wget cmds
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down


# autoload -Uz compinstall && compinstall
# configure key keybindings
# bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
# bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
# bindkey '^[[Z' undo                               # shift + tab undo last action

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

export MANPATH="/usr/local/man:$MANPATH"
# $(printf '%s="%s"\n' 'PATH' "$(printf "%s:" $(echo "${PATH}" | tr ':' '\n' | sort -u) )" | sed -e 's/:"/"/')
# export PATH

# ani-cli shit
# export ANI_CLI_EXTERNAL_MENU=0
#-----------[NNN]---------------------#
export NNN_OPTS="H" # 'H' shows the hidden files. Same as option -H (so 'nnn -deH')
export LC_COLLATE="C" # hidden files on top
export NNN_FIFO=/tmp/nnn.fifo # temporary buffer for the previews
export NNN_PLUG='o:fzopen;e:-!sudo -E nvim $nnn*;c:cdpath;u:getplugs;i:imgview;h:-!hx $nnn*;p:preview-tui;x:!chmod +x $nnn;m:!mpv $nnn'
export SPLIT='v' # to split Kitty vertically

NNN_TMPFILE='/tmp/.lastd'
BLK="04" CHR="04" DIR="04" EXE="00" REG="00" HARDLINK="00" SYMLINK="06" MISSING="00" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="02"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
    source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi

# export FZF_DEFAULT_OPTS="
#   --color=fg:#ff007c,bg:-1,hl:#03d8f3 --color=fg+:#00ffc8,bg+:,hl+:#03d8f3 
#   --color=info:#ff0055,prompt:#fcee0c,pointer:#ffb800 --color=marker:#00ffc8,spinner:#ffb800,header:#fcee0c
#   --reverse --border=rounded
# "
# Custom Pink & Black theme
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#ff5f87,hl:#008ec4 --color=fg+:#d75f87,bg+:#4e4e4e,hl+:#5fd7ff --color=info:#afaf87,prompt:#c30771,pointer:#af5fff --color=marker:#c30771,spinner:#af5fff,header:#a790d5'
# umask 022 to set default permissions
# export PATH="$PATH:/home/sweet/.bin"


# source aliases and personal scripts
source "$HOME/.config/zsh/alias.zsh"
source "$HOME/.config/zsh/functions.zsh"
source "$HOME/.config/zsh/fzf.zsh"
source "$HOME/.config/zsh/xport.zsh"

# source auto suggestions and syntax highlighting (syntax needs to be last)
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# ZSH_AUTOSUGGEST_STRATEGY=(history)
# Remove forward-char widgets from ACCEPT
# ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
# Add forward-char widgets to PARTIAL_ACCEPT
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)

source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"