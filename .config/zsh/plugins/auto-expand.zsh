_expand-abbrev() {
  local lastword="${LBUFFER##* }"
  lastword="${lastword#\'}"
  lastword="${lastword#\"}"
  lastword="${lastword#*=}"
  local op=""
  case "$lastword" in
    ".c")
      if git root 2>/dev/null >/dev/null; then
        op="commit"
      fi;;
    ".d")
      if git root 2>/dev/null >/dev/null; then
        op="dirty"
      fi;;
    ".b")
      if git root 2>/dev/null >/dev/null; then
        op="branch"
      fi;;
    ".f") op="file";;
  esac

  if [[ -z "$op" ]]; then
    zle menu-complete
  else
    local result=""
    case "$op" in
      "commit") result=$(git log --oneline --topo-order --decorate -n100 | fzf --exit-0 --select-1 --multi --reverse | cut -d' ' -f1);;
      "dirty")
        local gitroot=$(git root)
        # this is kinda hairy... the perl mess gives you a nice relative path
        # so you can use this with git add, and you don't have to deal with
        # an absolute path since usually you don't need to
        result=$( \
          git -C "$gitroot" ls-files --exclude-standard --modified --others \
        | fzf --exit-0 --select-1 --height 6 --reverse --multi \
        | perl -e 'use File::Spec; while(<STDIN>) { print(File::Spec->abs2rel(File::Spec->catfile($ARGV[0], $_))); }' -- "$gitroot"
        );;
      "branch") result=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads | fzf --exit-0 --multi --select-1);;
      "file")  result=$(rg --files | fzf --exit-0 --multi);;
    esac
    replacement=""
    while IFS= read -r line; do
      escaped=$(printf '%q' "$line")
      if [[ ! -z "$replacement" ]]; then
        replacement="$replacement "
      fi
      replacement="$replacement$escaped"
    done <<< "$result"
    LBUFFER="${LBUFFER%"$lastword"}$replacement"
    zle redisplay
  fi
}

zle -N _expand-abbrev
bindkey "\t" _expand-abbrev
