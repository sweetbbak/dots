# ls aliases
aliases['la'] = 'ls -lAFh'     # long list, show almost all, show type, human readable
aliases['lr'] = 'ls -tRFh'     # sorted by date, recursive, show type, human readable
aliases['lt'] = 'ls -ltFh'     # long list, sorted by date, show type, human readable
aliases['ll'] = 'ls -l'        # long list
aliases['ldot'] = 'ls -ld .*'  # list hidden dot files

# tar can be... difficult
aliases['tarls'] = "tar -tvf"
aliases['untar'] = "tar -xf"

# networking
aliases['speedtest'] = "wget -O /dev/null http://speed.transip.nl/10mb.bin"

aliases['dud'] = 'du -d 1 -h'
# todo: track down why this doesn't work
#aliases['duf'] = 'du -sh *'
aliases['fd'] = 'find . -type d -name'  # find dir
aliases['ff'] = 'find . -type f -name'  # find file
aliases['e'] = 'exa --icons'
aliases['ee'] = 'exa --icons -l --group-directories-first'

def shrink_path(path, size=1):
    """Shrink a path so a shorter form"""
    import re
    # fish does a similar thing in its prompt_pwd
    path = re.sub(r'^' + $HOME + '($|/)', r'~\1', str(path))
    return re.sub(r'(\.?[^/]{' + str(size) + r'})[^/]*/', r'\1/', path)

	
# colored man pages
# https://xon.sh/customization.html#color-my-man-pages
# Colored man page support
# using 'less' env vars (format is '\E[<brightness>;<colour>m')
$LESS_TERMCAP_mb = "\033[01;31m"     # begin blinking
$LESS_TERMCAP_md = "\033[01;31m"     # begin bold
$LESS_TERMCAP_me = "\033[0m"         # end mode
$LESS_TERMCAP_so = "\033[01;44;36m"  # begin standout-mode (bottom of screen)
$LESS_TERMCAP_se = "\033[0m"         # end standout-mode
$LESS_TERMCAP_us = "\033[00;36m"     # begin underline
$LESS_TERMCAP_ue = "\033[0m"         # end underline