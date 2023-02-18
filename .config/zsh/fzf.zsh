export FZF_DEFAULT_COMMAND="rg ~ --files --hidden"
# export FZF_DEFAULT_OPTS="
#   --color=fg:#ff007c,bg:-1,hl:#03d8f3 --color=fg+:#00ffc8,bg+:,hl+:#03d8f3 
#   --color=info:#ff0055,prompt:#fcee0c,pointer:#ffb800 --color=marker:#00ffc8,spinner:#ffb800,header:#fcee0c
#   --reverse --border=rounded
# "

# Oxocarbon theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#ee5396,bg:#161616,hl:#08bdba --color=fg+:#ee5396,bg+:#262626,hl+:#3ddbd9 --color=info:#78a9ff,prompt:#33b1ff,pointer:#42be65 --color=marker:#ee5396,spinner:#ff7eb6,header:#be95ff
  --reverse --border=rounded
'

export FZF_ALT_C_COMMAND="fd -t d -d 1"
export FZF_ALT_C_OPTS="--preview 'tree -C {}|head -200' --height=60%"
export FZF_PREVIEW_ADVANCED=true
export LESSOPEN='|~/.oh-my-zsh/custom/lessfilter.sh %s'
