#Author: Malsententia <Malsententia@gmail.com>
#Purpose: Colorized man pages, with random themes seeded by
#         the command and/or section. That is, every man page
#         has its own consistent color scheme. For example
#         man tar is always yellow, green, and blue, man less
#         is always pink, blue, and yellow, etc.(on zsh, anyway)
#Note: Colorization will differ between bash and zsh, since their 
#      RNGs are different
#Requires: bash or zsh(may support others), and perl
#Setup: Name it .mancolor.sh, source it in your bashrc/zshrc,
#       and chmod +x it(it also gets run as a script)
#       If you name it something else or put it somewhere else,
#       change this:
export MANCOLORPATH=$HOME/.config/home-manager/modules/zsh/mancolor.zsh
#If you want it to use just the man section as the seed change this
# to 1. Man pages of the same section will have the same schemes.
export USESECTION=0

#Quick and dirty changelog:
#2014-07-21 04:00: Initial public release
#2014-07-21 08:00: added "category" seed support
#2014-07-21 09:00: fixed bug where zsh didn't like stuff with hyphens
#2014-07-22 13:30: Fixed so man -w is used, rather than the args,
#                  so now man 1 man and man man are the same,
#                  NOTE: Breaks consistency with previous coloration,
#                  themes will not match those seen prior to this.
#                  Sorry if you got used to your pink and blue tar page.
#                  Also fixed improperly referring to sections as
#                  categories
#2014-07-22 18:40: Oops, looks like I derped while writing my perl 
#                  regular expressions. Changed that "/ga" to "/g"
#2014-07-24 02:20: Misc cleanup.
#2014-09-23 02:20: Tacked $USER onto the shitty random seed workaround
#                  to avoid users having conflicting seed files. Still
#                  probably a better way to do the whole seed passing thing.

#Tips welcome: 1MAnCLrnkbrNZSPaQ7PfUSQZYjez17PaG5

#The author disclaims copyright to this source code.  In place of
#a legal notice, here is a blessing:
#   May you do good and not evil.
#   May you find forgiveness for yourself and forgive others.
#   May you share freely, never taking more than you give.

#For those not in the know, the 256 color pallete consists of
#the basic 16 colors at the end, the 25 colorblack-white gradient at
#the end, with 216 colors in between. The numbers of the colors is
#base 6, RGB. ie, 000 is black, 555 is white, 500 is red etc
# for yellow, b6color would be used like: b6color 5 5 0
[[ $- == *i* ]] && b6color(){
    echo -n $((6#$1$2$3+16))
}&& RND(){
    #BASH doesn't carry the RANDOM seed to subshells,so this is a
    #shitty workaround, since I wanted this to work outside of zsh.
    #Was gonna use /dev/shm, but wasn't sure that non linux unixen 
    #provided that.
    RANDOM=$(</tmp/mancolorseed$USER)
    echo -n $(($(</tmp/mancolorseed$USER)+1))>/tmp/mancolorseed$USER
    echo -en $RANDOM
}&& man() {
    echo -n "$((16#$(MANPAGER=cat /bin/man -w "$@" 2>/dev/null | grep -Poh "(?<=/)[^/]+\.[^\\\.]+(?=\.gz\$)" | md5sum | head -c 4)/2))">/tmp/mancolorseed$USER
    if ((USESECTION==1)); then
        local sec="$(MANPAGER=cat /bin/man -w "$@" 2>/dev/null | grep -Pohm 1 '\d(?=\w*?.gz)')"
        [[ -n "$sec" ]]&& echo -n "$sec">/tmp/mancolorseed$USER
    fi
    local mbColor=$(b6color 5 $(($(RND)%3)) 0)
    local mdColor
    if (($(RND)%2)); then
        mdColor=$(b6color $(($(RND)%5)) 5 0)
    else
        mdColor=$(b6color $(($(RND)%3+2)) 0 5)
    fi
    local secColor=$(b6color $(($(RND)%6)) 2 5)
    local soColor
    case $(($(RND)%6)) in
        0)
            soColor=$(b6color 5 $(($(RND)%6)) 0)
            ;;
        1)
            soColor=$(b6color $(($(RND)%6)) 5 0)
            ;;
        2)
            soColor=$(b6color 0 5 $(($(RND)%6)))
            ;;
        3)
            soColor=$(b6color 0 $(($(RND)%4+2)) 5)
            ;;
        4)
            soColor=$(b6color $(($(RND)%4+2)) 0 5)
            ;;
        5)
            soColor=$(b6color 5 0 $(($(RND)%6)))
            ;;
    esac
    local default
    #If you find the main text colors are too colored, and you want them
    #closer to white, change the "%3+3"s to "%2+4"s, and the single 3s to 4s
    case $(($(RND)%6)) in
        0)
            default=$(b6color 5 $(($(RND)%3+3)) 3)
            ;;
        1)
            default=$(b6color $(($(RND)%3+3)) 5 3)
            ;;
        2)
            default=$(b6color 3 5 $(($(RND)%3+3)))
            ;;
        3)
            default=$(b6color 3 $(($(RND)%3+3)) 5)
            ;;
        4)
            default=$(b6color $(($(RND)%3+3)) 3 5)
            ;;
        5)
            default=$(b6color 5 3 $(($(RND)%3+3)))
            ;;
    esac
    local usColor
    if (($(RND)%2)); then
        usColor=$(b6color 0 $(($(RND)%4+2)) 5)
    else
        usColor=$(b6color 5 0 $(($(RND)%6)))
    fi
    local topColor
    if (($(RND)%2)); then
        topColor=$(b6color 5 $(($(RND)%6)) 0)
    else
        topColor=$(b6color 5 0 $(($(RND)%3)))
    fi
    env \
    normColor=$'\e'"[0;38;5;${default}m" \
    sectionColor=$'\e'"[1;38;5;${secColor}m" \
    footColor=$'\e'"[1;48;5;235;38;5;${topColor}m" \
    headColor=$'\e'"[1;38;5;234;48;5;${topColor}m" \
    MANPAGER="$MANCOLORPATH" \
    LESS_TERMCAP_mb=$'\e'"[1;5;48;5;${mbColor}m" \
    LESS_TERMCAP_md=$'\e'"[1;38;5;${mdColor}m" \
    LESS_TERMCAP_me=$'\e'"[0;38;5;${default}m" \
    LESS_TERMCAP_se=$'\e'"[0;38;5;${default}m" \
    LESS_TERMCAP_so=$'\e'"[1;38;5;232;48;5;${soColor}m" \
    LESS_TERMCAP_ue=$'\e'"[0;38;5;${default}m" \
    LESS_TERMCAP_us=$'\e'"[1;4;38;5;${usColor}m" \
    man "$@"
} || perl -pe '
$.==1 && s/^(.*)$/'${headColor}'\1'${normColor}'/;
eof && s/^(.*)$/'${footColor}'\1'${normColor}'/;
s/^/'${normColor}'/;
/^[^\t A-Z]+[A-Z0-9\x08]+[^a-z]+(?!   )$/ && s/\x08.//g && s/^([^\t A-Z]+)([A-Z0-9\x08]+[^a-z]+)(?!   )$/\1'${sectionColor}'\2/g' | \
less "$@"
