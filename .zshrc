# export PATH=$PATH:~/.local/bin:~/bin:~/.cargo/bin:~/go/bin:~/dev/bin:~/.luarocks/bin:~/scripts:~/scripts/fzf-bin:~/src:~/node_modules/.bin:~/apps:~/apps/blender340:~/dev/bin
# export path+=(~/.local/bin ~/bin ~/.cargo/bin ~/go/bin ~/dev/bin ~/.luarocks/bin ~/scripts ~/scripts/fzf-bin ~/src ~/node_modules/.bin ~/apps ~/apps/blender340 ~/dev/bin)
# path+=$( fd . $HOME/bin/ -t d -d 1 -X printf " %s" {} )
export EDITOR='helix'
# export STARSHIP_CONFIG=~/example/non/default/path/starship.toml

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
export HISTDUP=erase

export VISUAL='Codium'
export PAGER='less -R'
export DIFFPROG="nvim -d"
export DOTBARE_DIR="$HOME/.dotfiles"
export DOTBARE_TREE="$HOME"
export DOTBARE_PREVIEW="bat -n {}"
export DOTBARE_BACKUP="/run/media/sweet/Hard Drive/linux-backups/dotbare"
# PATH=$PATH$( find $HOME/bin/ -type d -printf ":%p" )
# PATH=$PATH$( fd . $HOME/bin/ -t d -d 1 -X printf " %s" {} )
# path+=$( fd . $HOME/bin/ -t d -d 1 -X printf " %s" {} )
# PATH=$PATH$( find $HOME/scripts/ -type d -printf ":%p" ):$PATH
# export PATH=$HOME/.config/rofi/scripts:$PATH

# export BAT_THEME="Catppuccin-mocha"
# shellcheck source=/dev/null
source "$HOME/.cache/wal/colors.sh"

# fzf tab
# shellcheck source=/dev/null
source "$HOME/github/fzf-tab/fzf-tab.plugin.zsh"
# shellcheck source=/dev/null
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
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

zstyle ':completion:*' fzf-search-display true

# fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# History configurations
setopt autocd
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
# setopt hist_verify            # show command with history expansion to user before running it
setopt share_history         # share command history data
# setopt appendhistory
setopt sharehistory
setopt interactivecomments # allow comments in interactive mode
setopt numericglobsort     # sort filenames numerically when it makes sense

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
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# export MANPATH="/usr/local/man:$MANPATH"

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

# source aliases and personal scripts
# shellcheck source=/dev/null
source "$HOME/.config/zsh/alias.zsh"
# shellcheck source=/dev/null
source "$HOME/.config/zsh/functions.zsh"
# shellcheck source=/dev/null
source "$HOME/.config/zsh/fzf.zsh"
# shellcheck source=/dev/null
source "$HOME/.config/zsh/xport.zsh"
# shellcheck source=/dev/null
source ~/.config/zsh/colored-man.zsh

# source auto suggestions and syntax highlighting (syntax needs to be last)
# shellcheck source=/dev/null
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# ZSH_AUTOSUGGEST_STRATEGY=(history)
# Remove forward-char widgets from ACCEPT
# ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
# Add forward-char widgets to PARTIAL_ACCEPT
# ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)

# shellcheck source=/dev/null
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"