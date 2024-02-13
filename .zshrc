##########
# ENVVARS
##########
export EDITOR='helix'
export visual='kitty helix'
# export SHELL=/bin/bash
export HISTFILE=~/.config/zsh/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export PAGER='bat --color=always'
export DIFFPROG="nvim -d"
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT='-c'

# alias hx='/opt/helix-extended/hx'

# STARSHIP
# --- uncomment your theme ---
# STARSHIP_THEME="$HOME/.config/starship/blue.toml"
# STARSHIP_THEME="$HOME/.config/starship/bracketed-segments.toml"
# STARSHIP_THEME="$HOME/.config/starship/gruvbox-rainbow.toml"
# STARSHIP_THEME="$HOME/.config/starship/gum.toml"
# STARSHIP_THEME="$HOME/.config/starship/helix.toml"
# STARSHIP_THEME="$HOME/.config/starship/jetpack.toml"
# STARSHIP_THEME="$HOME/.config/starship/kali.toml"
# STARSHIP_THEME="$HOME/.config/starship/kana.toml"
# STARSHIP_THEME="$HOME/.config/starship/material.toml"
# STARSHIP_THEME="$HOME/.config/starship/nerd-font-symbols.toml"
# STARSHIP_THEME="$HOME/.config/starship/no-empty-icons.toml"
# STARSHIP_THEME="$HOME/.config/starship/no-nerd-font.toml"
# STARSHIP_THEME="$HOME/.config/starship/no-runtime-versions.toml"
# STARSHIP_THEME="$HOME/.config/starship/pastel-powerline.toml"
# STARSHIP_THEME="$HOME/.config/starship/plain-text-symbols.toml"
STARSHIP_THEME="$HOME/.config/starship/pure-preset.toml"
# STARSHIP_THEME="$HOME/.config/starship/pure.toml"
# STARSHIP_THEME="$HOME/.config/starship/starship.toml"
# STARSHIP_THEME="$HOME/.config/starship/terminal.toml"
# STARSHIP_THEME="$HOME/.config/starship/tokyo-night.toml"
# ---------------------------

# function prepend-sudo {
#   if [[ $BUFFER != "sudo "* ]]; then
#     BUFFER="sudo $BUFFER"; CURSOR+=5
#   fi
# }
# zle -N prepend-sudo

# bindkey -M vicmd s prepend-sudo
autoload edit-command-line
zle -N edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

/usr/bin/cat "$HISTFILE" | ~/dev/mybox/bin/uniq2 >> "${HISTFILE}.bak"

# eval "$(direnv hook zsh)"

# select all
function _ctrl-a {
  MARK=0
  CURSOR=$#BUFFER
  REGION_ACTIVE=1
}

zle -N _ctrl-a _ctrl-a
bindkey '^s' _ctrl-a

autoload -Uz surround
zle -N add-surround surround
bindkey -a ms add-surround

[ -z "${STARSHIP_ON}" ] && {
  export STARSHIP_ON=1
}

export STARSHIP_CONFIG="$STARSHIP_THEME"

if command -v starship >/dev/null && [ "$STARSHIP_ON" -eq 1 ]; then
  eval "$(starship init zsh)"
else
  # fallback prompt
  echo -e "\e[33;3mWelcome $USER\e[0m"
  PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
  RPROMPT='%*'
  export PROMPT RPROMPT
fi

# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  true
fi

# kitty
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi

# check if file exists and source it
function __source() {
  # shellcheck source=/dev/null
  [ -f "$1" ] && source "$1"
}

# KEYBINDS
WORDCHARS='~!#$%^&*(){}[]<>?.+;-'
bindkey '^[[1;5C' forward-word     # ctrl + ->
bindkey '^[[1;5D' backward-word    # ctrl + <-
bindkey '^H' backward-kill-word    # ctrl+backspace delete word
bindkey '^U' backward-kill-line    # ctrl+backspace delete word
bindkey ' ' magic-space            # history expansion on space
bindkey '^Z' undo                  # shift + tab undo last action

# zsh 4 humans
bindkey '^[/'     redo
# bindkey '^[[1;3D' backward-word
# bindkey '^[[1;3C' forward-word
# bindkey '^[[1;5D' backward-word
# bindkey '^[[1;5C' forward-word

bindkey '^f' emacs-forward-word
bindkey '^a' emacs-backward-word

# history binds - match characters history search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

#--- interesting auto-complete opts ---
# ZSH_AUTOSUGGEST_STRATEGY=(history)
# Remove forward-char widgets from ACCEPT
# ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
# Add forward-char widgets to PARTIAL_ACCEPT
# ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)

# OPTIONS
setopt extendedglob
setopt auto_cd
setopt auto_pushd
setopt interactive_comments
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$_zcompcache"

setopt EXTENDED_HISTORY
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Dont write duplicate entries in the history file.

# Initialize completion styles. Users can set their preferred completion style by
# calling `compstyle <compstyle>` in their .zshrc, or by defining their own
# `compstyle_<name>_setup` functions similar to the zsh prompt system.
fpath+="${0:A:h}/functions"
# autoload -Uz compstyleinit && compstyleinit

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
# autoload -Uz compinit
# _zcompdump=~/.cache/zcompdump
# _comp_files=($_zcompdump(Nmh-20))
# if (( $#_comp_files )); then
#   compinit -i -C -d "$_zcompdump"
# else
#   compinit -i -d "$_zcompdump"
#   # Keep $_zcompdump younger than cache time even if it isn't regenerated.
#   touch "$_zcompdump"
# fi

# cleanup
# unset _cache_dir _comp_files _zcompdump _zcompcache

autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# zsh history
# setopt hist_ignore_dups
# setopt hist_find_no_dups
# setopt hist_save_no_dups
# setopt hist_verify
# setopt appendhistory
# setopt extended_history
# setopt inc_append_history_time

setopt hist_ignore_space
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt inc_append_history
setopt share_history
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

export HISTORY_IGNORE="(ls|cd|pwd|exit|rm)"


# SOURCE
# aliases
__source "$HOME/.config/zsh/alias.zsh"

# personal functions
__source "$HOME/.config/zsh/functions.zsh"

# default fzf options
__source "$HOME/.config/zsh/fzf.zsh"

# --- fzf tab ---
# this needs to be sourced before auto-suggestions and highlighting
__source "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
__source "$HOME/.config/zsh/plugins/fzf-history/zsh-fzf-history-search.zsh"

# double tap ESC to prepend line with SUDO
__source "$HOME/.config/zsh/zsh-sudo-plugin.zsh"

# auto color cmd output with regex (pretty color output for ping - ps - etc...)
# install grc - pacman -S grc
# this unfortunately breaks some CLI pipes and such
# __source /etc/grc.zsh

# __source ~/.config/zsh/plugins/colored-man.zsh
__source "$HOME/.config/zsh/zsh-dirhistory-plugin.zsh"

# source auto suggestions
__source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# tab sources for better completion
zstyle ':autocomplete:*' default-context history-incremental-search-backward
# __source "$HOME/.config/zsh/plugins/fzf-tab-source/fzf-tab-source.plugin.zsh"

# COMPLETION
zstyle ':completion:*' fzf-search-display true

zle -C alias-expension complete-word _generic
bindkey '^e' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# FZF TAB COMPLETE
###################
# disable preview for command options
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview

# zstyle ':fzf-tab:complete:kitten:icat:*' fzf-preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 $realpath'
# zstyle ':fzf-tab:complete:kitten:icat:*' fzf-preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=10x10@0x0 ${(Q)realpath}'
# zstyle ':fzf-tab:complete:icat:argument-1' fzf-preview \
#   'kitten icat --clear --transfer-mode=memory --stdin=no --place=30x30@0x0 {}'

# zstyle ':fzf-tab:complete:(\\|*/|)kitty:*' fzf-preview

# zstyle ':fzf-tab:complete:icat:*' fzf-preview \
#   'kitten icat --clear --transfer-mode=stream --stdin=no --place=10x10@0x0 ${realpath} | sed \$d' \
#   fzf-flags --preview-window=down:3:wrap

# zstyle ':fzf-tab:complete:icat:argument-1' fzf-preview \
#   fzf-flags --preview-window=down:3:wrap --preview='kitten icat --clear --transfer-mode=stream --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}'
  # 'kitten icat --clear --transfer-mode=stream --stdin=no --place=10x10@0x0 ${word}' \

# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
zstyle ':fzf-tab:complete:lx:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# it is an example. you can change it
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

# less open
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
# export LESSOPEN='|~/scripts/lessfilter.sh %s'

# tldr
 zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
###################

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':fzf-tab:complete:*' fzf-bindings \
	'ctrl-v:execute-silent({_FTB_INIT_}code "$realpath")' \
    'ctrl-e:execute-silent({_FTB_INIT_}kitty helix "$realpath")'

# TMUX popup
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0

# zstyle ':fzf-tab:*' popup-min-size 50 8
# zstyle ':fzf-tab:complete:diff:*' popup-min-size 80 12

# _zsh_autosuggest_strategy_histdb_top_here() {
#     local query="select commands.argv from
# history left join commands on history.command_id = commands.rowid
# left join places on history.place_id = places.rowid
# where places.dir LIKE '$(sql_escape $PWD)%'
# and commands.argv LIKE '$(sql_escape $1)%'
# group by commands.argv order by count(*) desc limit 1"
#     suggestion=$(_histdb_query "$query")
# }

# ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here
# __source "$HOME/.config/zsh/plugins/sql_fzf_history.zsh"

# Syntax highlighting must be loaded last
__source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
