incsearch_hooks_enter=()
incsearch_hooks_leave=()

incsearch-forward() {
    incsearch-enter 1 1
}

incsearch-backward() {
    incsearch-enter -1 1
}

incsearch-forward-beginning() {
    incsearch-enter 1 0
}

incsearch-backward-beginning() {
    incsearch-enter -1 0
}

incsearch-enter() {
    incsearch_dir=$1
    incsearch_to_end=$2
    incsearch_input=""
    incsearch_start=$(( $CURSOR + $incsearch_dir ))
    incsearch_postdisplay_save="$POSTDISPLAY"
    (( $incsearch_start < 0 )) && incsearch_start=0
    (( $incsearch_start > $#BUFFER - 1 )) && incsearch_start=$(( $#BUFFER - 1 ))

    zle -A self-insert saved-self-insert
    zle -A accept-line saved-accept-line
    zle -A backward-delete-char saved-backward-delete-char
    zle -N self-insert incsearch-self-insert
    zle -N accept-line incsearch-leave
    zle -N backward-delete-char incsearch-backward-delete-char

    incsearch-update-display

    for hook in $incsearch_hooks_enter; do
        eval "$hook"
    done
}

incsearch-leave() {
    POSTDISPLAY="$incsearch_postdisplay_save"
    unset incsearch_postdisplay_save
    unset incsearch_dir
    unset incsearch_input

    zle -A saved-self-insert self-insert
    zle -A saved-accept-line accept-line
    zle -A saved-backward-delete-char backward-delete-char
    zle -D saved-self-insert
    zle -D saved-accept-line
    zle -D saved-backward-delete-char

    for hook in $incsearch_hooks_leave; do
        eval "$hook"
    done
}

incsearch-self-insert() {
    incsearch_input="${incsearch_input}${KEYS}"
    incsearch-exec
}

incsearch-backward-delete-char() {
    incsearch_input=${incsearch_input[1,(($#incsearch_input - 1))]}
    incsearch-exec
}

incsearch-exec() {
    INDEX=$(incsearch-index-of "$BUFFER" "$incsearch_input" "$incsearch_start" "$incsearch_dir")
    if [ $? = 0 ]; then
        if [ $incsearch_to_end = 0 ]; then
            CURSOR=$INDEX
        else
            CURSOR=$(($INDEX + $#incsearch_input - 1))
        fi
    fi
    incsearch-update-display
}

incsearch-update-display() {
    POSTDISPLAY=$'\n'"search: ${incsearch_input}_"
}

# From https://github.com/soheilpro/zsh-vi-search/blob/445c8a27dd2ce315176f18b4c7213c848f215675/src/zsh-vi-search.zsh
# Copyright (c) 2014 Soheil Rashidi
incsearch-index-of() {
    setopt localoptions no_sh_word_split
    local STR=$1
    local STRLEN=${#STR}
    local SUBSTR=$2
    local SUBSTRLEN=${#SUBSTR}
    local START=${3:-0}
    local DIRECTION=${4:-1}

    [[ $STRLEN -ge 0 ]] || return 1
    [[ $SUBSTRLEN -ge 0 ]] || return 2
    [[ $START -ge 0 ]] || return 3
    [[ $START -lt $STRLEN ]] || return 4
    [[ $DIRECTION -eq 1 || $DIRECTION -eq -1 ]] || return 5

    for ((INDEX = $START; INDEX >= 0 && INDEX < $STRLEN; INDEX = INDEX + $DIRECTION)); do
        if [[ "${STR:$INDEX:$SUBSTRLEN}" == "$SUBSTR" ]]; then
            echo $INDEX
            return
        fi
    done

    return -1
}

zle -N incsearch-forward incsearch-forward
zle -N incsearch-backward incsearch-backward
zle -N incsearch-forward-beginning incsearch-forward-beginning
zle -N incsearch-backward-beginning incsearch-backward-beginning
