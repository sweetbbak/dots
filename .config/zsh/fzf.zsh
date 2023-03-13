export FZF_DEFAULT_COMMAND="rg ~ --files --hidden"
# export FZF_DEFAULT_OPTS="
#   --color=fg:#ff007c,bg:-1,hl:#03d8f3 --color=fg+:#00ffc8,bg+:,hl+:#03d8f3 
#   --color=info:#ff0055,prompt:#fcee0c,pointer:#ffb800 --color=marker:#00ffc8,spinner:#ffb800,header:#fcee0c
#   --reverse --border=rounded
# "

# rose pine moon
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
 # --color=fg:#e0def4,bg:#2a273f,hl:#6e6a86
 # --color=fg+:#908caa,bg+:#232136,hl+:#908caa
 # --color=info:#9ccfd8,prompt:#f6c177,pointer:#c4a7e7
 # --color=marker:#ea9a97,spinner:#eb6f92,header:#ea9a97"

# export FZF_DEFAULT_OPTS="
#   --color=fg:#ff007c,bg:-1,hl:#03d8f3 --color=fg+:#00ffc8,bg+:,hl+:#03d8f3 
#   --color=info:#ff0055,prompt:#fcee0c,pointer:#ffb800 --color=marker:#00ffc8,spinner:#ffb800,header:#fcee0c
#   --reverse --border=rounded
# "
# Custom Pink & Black theme
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#ff5f87,hl:#008ec4 --color=fg+:#d75f87,bg+:#4e4e4e,hl+:#5fd7ff --color=info:#afaf87,prompt:#c30771,pointer:#af5fff --color=marker:#c30771,spinner:#af5fff,header:#a790d5'
# umask 022 to set default permissions
# export PATH="$PATH:/home/sweet/.bin"


# rose pine
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
 --color=fg:#ea9a97,bg:#1f1d2e,hl:#6e6a86
 --color=fg+:#908caa,bg+:#191724,hl+:#908caa
 --color=info:#9ccfd8,prompt:#f6c177,pointer:#c4a7e7
 --color=marker:#ebbcba,spinner:#eb6f92,header:#ebbcba"

# Oxocarbon theme
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#ee5396,bg:#161616,hl:#08bdba --color=fg+:#ee5396,bg+:#262626,hl+:#3ddbd9 --color=info:#78a9ff,prompt:#33b1ff,pointer:#42be65 --color=marker:#ee5396,spinner:#ff7eb6,header:#be95ff
  # --reverse --border=rounded
# '

export FZF_ALT_C_COMMAND="fd -t d -d 1"
export FZF_ALT_C_OPTS="--preview 'tree -C {}|head -200' --height=60%"
export FZF_PREVIEW_ADVANCED=true
export LESSOPEN='|~/.config/zsh/lessfilter.sh %s'
