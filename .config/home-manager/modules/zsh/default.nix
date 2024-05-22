{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./alias.nix
  ];

  home.packages = [
    pkgs.zsh-autopair
    pkgs.zsh-fzf-history-search
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    # dotDir = ".config/zsh";
    dotDir = ".config/zsh";

    history.size = 100000;
    history.path = "${config.xdg.configHome}/zsh/history";
    history.ignorePatterns = ["top"];
    history.ignoreDups = true;
    history.ignoreAllDups = true;
    history.ignoreSpace = true;
    history.expireDuplicatesFirst = true;
    history.share = true;

    zprof.enable = false;
    envExtra = ''
      typeset -U path PATH
      export TZ=America/Anchorage
      path=(~/bin ~/scripts ~/.local/bin ~/go/bin ~/.cargo/bin $path)
      path=(~/.local/share/nvim/mason/bin $path)
    '';

    profileExtra = "";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "neovide";
      PAGER = "bat --color=always -p";
      DIFFPROG = "nvim -d";
      MANPAGER = "less -R --use-color -Dd+r -Du+b";
      MANROFFOPT = "-c";
      STARSHIP_CONFIG = "${config.xdg.configHome}/starship/gum.toml";
    };

    initExtra = ''
      source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
      printf "\x1b[38;5;116m%s\x1b[0m\n" "／人◕ ‿‿ ◕人＼"

      WORDCHARS='~!#$%^&*(){}[]<>?.+;-'
      setopt no_global_rcs
      #export EDITOR=nvim

      # KEYBINDS
      bindkey '^[[1;5C' forward-word       # ctrl + ->
      bindkey '^[[1;5D' backward-word      # ctrl + <-
      bindkey '^H'      backward-kill-word # ctrl+backspace delete word
      bindkey '^U'      backward-kill-line # ctrl+u delete line
      bindkey ' '       magic-space        # history expansion on space
      bindkey '^Z'      undo               # shift + tab undo last action
      bindkey '^[/'     redo

      # history binds - match characters history search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search

      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      bindkey "^[[A" up-line-or-beginning-search # Up
      bindkey "^[[B" down-line-or-beginning-search # Down

      bindkey "''${key[Up]}" up-line-or-beginning-search # Up
      bindkey "''${key[Down]}" down-line-or-beginning-search # Down

      # fpath+=".config/zsh/functions"
      eval "$(direnv hook zsh)"
      if command -v starship >/dev/null; then
          eval "$(starship init zsh)"
      else
          echo -e "\e[33;3mWelcome $USER\e[0m"
          PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '
          RPROMPT='%*'
          export PROMPT RPROMPT
      fi

      if command -v zoxide &>/dev/null; then
          eval "$(zoxide init --cmd cd zsh)"
          true
      fi

      # Kitty
      if test -n "$KITTY_INSTALLATION_DIR"; then
          export KITTY_SHELL_INTEGRATION="enabled"
          autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
          kitty-integration
          unfunction kitty-integration
      fi

      zstyle ":completion:*" matcher-list 'm:{a-z}={A-Za-z}'
      . $HOME/.config/home-manager/modules/zsh/opts.zsh
      . $HOME/.config/home-manager/modules/zsh/functions.zsh
      . $HOME/.config/home-manager/modules/zsh/zsh-sudo-plugin.zsh

    '';

    plugins = [
      {
        name = "zsh-fzf-history-search";
        src = pkgs.fetchFromGitHub {
          owner = "joshskidmore";
          repo = "zsh-fzf-history-search";
          rev = "741012388886e7ee39330fe3cdb6a4803012dc0b";
          sha256 = "sha256-RqQGDMCb7+TMRG/ITNkQsRJhbhGkGq3ogdbUNHNvv6U=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "f3d892cf19bba09c0c44fa9fcaf6d616fe5b18e6";
          sha256 = "sha256-CZrFf79mat70E3QAQ4jVdICoyOHFiMn7Fv3Z+yAXnCA=";
        };
      }
      {
        name = "sudo.plugin.zsh";
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh";
          sha256 = "sha256-pXylDddgevJlHbVYFRz7L+oBOb8hQbGWi4e7Z9lcLFk=";
        };
      }
    ];
  };
}
