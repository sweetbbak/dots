# load functionalities like conda, hoard etc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/sweet/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/sweet/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/sweet/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/sweet/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<
#conda deactivate


# shellcheck disable=SC2034,SC2153,SC2086,SC2155

# Above line is because shellcheck doesn't support zsh, per
# https://github.com/koalaman/shellcheck/wiki/SC1071, and the ignore: param in
# ludeeus/action-shellcheck only supports _directories_, not _files_. So
# instead, we manually add any error the shellcheck step finds in the file to
# the above line ...

# Source this in your ~/.zshrc
# autoload -U add-zsh-hook

# _hoard_list(){
# 	emulate -L zsh
# 	zle -I

# 	echoti rmkx
#     # Similar to bash plugin in hoard.bash
# 	output=$(hoard --autocomplete list 3>&1 1>&2 2>&3)
# 	echoti smkx

# 	if [[ -n $output ]] ; then
# 		LBUFFER=$output
# 	fi

# 	zle reset-prompt
# }

# zle -N _hoard_list_widget _hoard_list

# if [[ -z $HOARD_NOBIND ]]; then
# 	bindkey '^h' _hoard_list_widget

# 	# depends on terminal mode
# 	#bindkey '^[[A' _hoard_list_widget
# 	#bindkey '^[OA' _hoard_list_widget
# fi

# nn ()
# {
#     # Block nesting of nnn in subshells
#     if [[ "${NNNLVL:-0}" -ge 1 ]]; then
#         echo "nnn is already running"
#         return
#     fi

#     export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
#     \nnn "$@"

#     if [ -f "$NNN_TMPFILE" ]; then
#             . "$NNN_TMPFILE"
#             rm -f "$NNN_TMPFILE" > /dev/null
#     fi
# }
