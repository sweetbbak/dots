export EDITOR='helix'
export visual='kitty helix'
export SHELL=/bin/bash
export HISTFILE=~/.config/zsh/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export PAGER='bat --color=always'
export DIFFPROG="nvim -d"
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT='-c'

# STARSHIP
# --- uncomment your theme ---
# STARSHIP_THEME="$HOME/.config/starship/starship.toml"
STARSHIP_THEME="$HOME/.config/starship/gum.toml"
# STARSHIP_THEME="$HOME/.config/starship/kana.toml"
# STARSHIP_THEME="$HOME/.config/starship/terminal.toml"
# STARSHIP_THEME="$HOME/.config/starship/helix.toml"
# STARSHIP_THEME="$HOME/.config/starship/material.toml"
# ---------------------------

# __inshellisense__() {
#     input=$LBUFFER
#     LBUFFER=
#     inshellisense -c "$input" -s zsh < $TTY
#     print -s $(inshellisense --history)
#     zle reset-prompt
# }

# zle     -N   __inshellisense __inshellisense__
# bindkey '^w' __inshellisense

# function prepend-sudo {
#   if [[ $BUFFER != "sudo "* ]]; then
#     BUFFER="sudo $BUFFER"; CURSOR+=5
#   fi
# }
# zle -N prepend-sudo

# bindkey -M vicmd s prepend-sudo

# /usr/bin/cp "$HISTFILE" "${HISTFILE}.bak"

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

# eval "$(pixi completion --shell zsh)"

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
# setopt auto_param_slash
# setopt always_to_end
setopt interactive_comments
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$_zcompcache"

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
# setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt inc_append_history
setopt share_history
export HISTORY_IGNORE="(ls|cd|pwd|exit|rm)"


# SOURCE
# aliases
__source "$HOME/.config/zsh/alias.zsh"

# personal functions
__source "$HOME/.config/zsh/functions.zsh"

# default fzf options
__source "$HOME/.config/zsh/fzf.zsh"

# double tap ESC to prepend line with SUDO
__source "$HOME/.config/zsh/zsh-sudo-plugin.zsh"

#+BEGIN_SRC zsh
# __source "$HOME/.config/zsh/plugins/zsh-histdb/zsh-histdb.plugin.zsh"
# autoload -Uz add-zsh-hook
#+END_SRC

# --- fzf tab ---
__source "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
__source "$HOME/.config/zsh/plugins/fzf-history/zsh-fzf-history-search.zsh"

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
__source "$HOME/.config/zsh/plugins/fzf-tab-source/fzf-tab-source.plugin.zsh"

# COMPLETION
zstyle ':completion:*' fzf-search-display true

zle -C alias-expension complete-word _generic
bindkey '^e' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# disable preview for command options
zstyle ':fzf-tab:complete:*:options' fzf-preview 
# zstyle ':fzf-tab:complete:*:options*' fzf-preview 
# zstyle ':fzf-tab:complete:*:options:*' fzf-preview 
# zstyle ':fzf-tab:complete:ls:*Pictures*' fzf-preview 'kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}'
zstyle ':fzf-tab:complete:icat:*' fzf-preview 'kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}'

# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:eww:open:*' fzf-preview 'eww windows'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# disable preview for subcommands
# zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
# zstyle ':fzf-tab:complete:*:argument-2' fzf-preview

zstyle ':fzf-tab:complete:*' fzf-bindings \
	'ctrl-v:execute-silent({_FTB_INIT_}code "$realpath")' \
    'ctrl-e:execute-silent({_FTB_INIT_}helix "$realpath")'

# fzf preview images
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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
