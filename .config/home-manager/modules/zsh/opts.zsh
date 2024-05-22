      # COMPLETION
      zstyle ':completion:*' fzf-search-display true

      zle -C alias-expension complete-word _generic
      bindkey '^e' alias-expension
      zstyle ':completion:alias-expension:*' completer _expand_alias

      # FZF TAB COMPLETE
      ###################
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:eza:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
      zstyle ':fzf-tab:complete:ls:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
      zstyle ':fzf-tab:complete:lx:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'

      zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

      zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
      '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'

      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

      zstyle ':fzf-tab:*' switch-group ',' '.'

      zstyle ':completion:*:git-checkout:*' sort false

      zstyle ':completion:*:descriptions' format '[%d]'

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


      zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
      # zstyle ':completion:*' list-colors ''${s.:. LS_COLORS}

      function icat() {
          kitten icat "$@"
      }
      # FZF TAB COMPLETE
      ###################
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:eza:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
      zstyle ':fzf-tab:complete:ls:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
      zstyle ':fzf-tab:complete:lx:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'

      zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

      zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
      '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'

      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

      zstyle ':fzf-tab:*' switch-group ',' '.'

      zstyle ':completion:*:git-checkout:*' sort false

      zstyle ':completion:*:descriptions' format '[%d]'

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


      zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
      # zstyle ':completion:*' list-colors ''${s.:. LS_COLORS}

      function icat() {
          kitten icat "$@"
      }
      # FZF TAB COMPLETE
      ###################
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:eza:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
      zstyle ':fzf-tab:complete:ls:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'
      zstyle ':fzf-tab:complete:lx:*' fzf-preview '/home/sweet/scripts/lessfilter.sh $realpath'

      zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

      zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
      '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'

      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

      zstyle ':fzf-tab:*' switch-group ',' '.'

      zstyle ':completion:*:git-checkout:*' sort false

      zstyle ':completion:*:descriptions' format '[%d]'

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


      zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color=always $word'
      # zstyle ':completion:*' list-colors ''${s.:. LS_COLORS}

      function icat() {
          kitten icat "$@"
      }
