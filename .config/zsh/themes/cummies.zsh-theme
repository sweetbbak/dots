PROMPT='
%{$fg_bold[blue]%}%~%{$fg_bold[blue]%}%{$fg_bold[magenta]%} % %{$reset_color%}
%{$fg[magenta]%}❱  %{$reset_color%}'

RPROMPT='$(git_prompt_info) $(ruby_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}[雨:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}] %{$fg[red]%}✖ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}] %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[blue]%}["
ZSH_THEME_RUBY_PROMPT_SUFFIX="]%{$reset_color%}"
