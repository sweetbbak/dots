{
  programs.zsh.shellAliases = {
    ls = "eza --icons=always";
    ll = "eza --icons=always -lah";
    e = "eza --icons=always --color=always";
    ee = "eza --icons=always --color=always -A";
    tree = "eza -a -I .git --tree";
    du = "du -sh";
    nv = "nvim";
    pm = "podman";
    cat = "bat -p --italic-text=always";
    eip = "echo $(curl -s http://ifconfig.me)";

    # ignore loop devices
    lsblk = "lsblk -e7";
    aplay_tts = "aplay -r 22050 -c 1 -f S16_LE -t raw";

    hx = "nvim";
    top = "btop";
    py = "python";

    mpvv = "mpv --vo=kitty --vo-kitty-use-shm=yes";
    mpvs = "mpv --vo=kitty --vo-kitty-use-shm=yes ytdl://ytsearch:";
    ydl = "yt-dlp";
    ytd = "yt-dlp --embed-thumbnail --embed-metadata";
    yta = "yt-dlp --embed-thumbnail --embed-metadata -x";
    mv = "mv -i";
    cp = "cp -rvn";
    grep = "grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}";

    # Utility functions for Core utils
    wget-pdf = "wget -r -l 1 -nH -nd -np --ignore-case -A '*.pdf'";
    zrc = "hx ~/.zshrc && source ~/.zshrc";

    # GO
    gmi = "go mod init";
    gmt = "go mod tidy";
    gb = "go build";

    # rsync
    rsync-copy = "rsync -avz --progress -h";
    rsync-move = "rsync -avz --progress -h --remove-source-files";
    rsync-update = "rsync -avzu --progress -h";
    rsync-synchronize = "rsync -avzu --delete --progress -h";

    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    chx = "chmod +x";
    fix-perms-dirs = "find /home/sweet/bin -type d -exec chmod 774 {} +";
    fix-perms-files = "find /home/sweet/bin -type f -exec chmod 664 {} +";

    # Git
    gcl = "git clone";
    tsm = "transmission-remote";
    config = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
  };

  programs.zsh.shellGlobalAliases = {
    G = "| grep";
  };
}
