## Fzf

# Update the list of processes by pressing CTRL-R
$ ps -ef | fzf --bind 'ctrl-r:reload(ps -ef)' --header 'Press CTRL-R to reload' \\
            --header-lines=1 --layout=reverse

# Integration with ripgrep
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="foobar"
FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \\
fzf --bind "change:reload:$RG_PREFIX {q} || true" \\
   --ansi --disabled --query "$INITIAL_QUERY"

# A preview binding with no default preview command
# (Preview window is initially empty)
$ fzf --bind '?:preview:cat {}'

# Default preview command with an extra preview binding
$ fzf --preview 'file {}' --bind '?:preview:cat {}'

# Preview window hidden by default, it appears when you first hit '?'
$ fzf --bind '?:preview:cat {}' --preview-window hidden

# Rotate through the options using CTRL-/
$ fzf --preview 'cat {}' --bind 'ctrl-/:change-preview-window(right,70%|down,40%,border-horizontal|hidden|right)'

# The default properties given by `--preview-window` are inherited, so an empty string in the list is interpreted as the default
$ fzf --preview 'cat {}' --preview-window 'right,40%,border-left' --bind 'ctrl-/:change-preview-window(70%|down,border-top|hidden|)'

# This is equivalent to toggle-preview action
$ fzf --preview 'cat {}' --bind 'ctrl-/:change-preview-window(hidden|)'

# Display top 3 lines as the fixed header
$ fzf --preview 'bat --style=full --color=always {}' --preview-window '~3'
    
# Field separators
_  1 "      The 1st field"
_  2 "      The 2nd field"
_  -1 "     The last field"
_  -2 "     The 2nd to last field"
_  3..5 "   From the 3rd field to the 5th field"
_  2.. "    From the 2nd field to the last field"
_  ..-3 "   From the 1st field to the 3rd to the last field"
_  .. "     All the fields"

## AVAILABLE ACTIONS:
# A key or an event can be bound to one or more of the following actions.

  \fBACTION:                   DEFAULT BINDINGS (NOTES):
    \fBabort\fR                      \fIctrl-c  ctrl-g  ctrl-q  esc\fR
    \fBaccept\fR                     \fIenter   double-click\fR
    \fBaccept-non-empty\fR           (same as \fBaccept\fR except that it prevents fzf from exiting without selection)
    \fBbackward-char\fR              \fIctrl-b  left\fR
    \fBbackward-delete-char\fR       \fIctrl-h  bspace\fR
    \fBbackward-delete-char/eof\fR   (same as \fBbackward-delete-char\fR except aborts fzf if query is empty)
    \fBbackward-kill-word\fR         \fIalt-bs\fR
    \fBbackward-word\fR              \fIalt-b   shift-left\fR
    \fBbeginning-of-line\fR          \fIctrl-a  home\fR
    \fBcancel\fR                     (clear query string if not empty, abort fzf otherwise)
    \fBchange-preview(...)\fR        (change \fB--preview\fR option)
    \fBchange-preview-window(...)\fR (change \fB--preview-window\fR option; rotate through the multiple option sets separated by '|')
    \fBchange-prompt(...)\fR         (change prompt to the given string)
    \fBclear-screen\fR               \fIctrl-l\fR
    \fBclear-selection\fR            (clear multi-selection)
    \fBclose\fR                      (close preview window if open, abort fzf otherwise)
    \fBclear-query\fR                (clear query string)
    \fBdelete-char\fR                \fIdel\fR
    \fBdelete-char/eof\fR            \fIctrl-d\fR (same as \fBdelete-char\fR except aborts fzf if query is empty)
    \fBdeselect\fR
    \fBdeselect-all\fR               (deselect all matches)
    \fBdisable-search\fR             (disable search functionality)
    \fBdown\fR                       \fIctrl-j  ctrl-n  down\fR
    \fBenable-search\fR              (enable search functionality)
    \fBend-of-line\fR                \fIctrl-e  end\fR
    \fBexecute(...)\fR               (see below for the details)
    \fBexecute-silent(...)\fR        (see below for the details)
    \fBfirst\fR                      (move to the first match)
    \fBforward-char\fR               \fIctrl-f  right\fR
    \fBforward-word\fR               \fIalt-f   shift-right\fR
    \fBignore\fR
    \fBjump\fR                       (EasyMotion-like 2-keystroke movement)
    \fBjump-accept\fR                (jump and accept)
    \fBkill-line\fR
    \fBkill-word\fR                  \fIalt-d\fR
    \fBlast\fR                       (move to the last match)
    \fBnext-history\fR               (\fIctrl-n\fR on \fB--history\fR)
    \fBpage-down\fR                  \fIpgdn\fR
    \fBpage-up\fR                    \fIpgup\fR
    \fBhalf-page-down\fR
    \fBhalf-page-up\fR
    \fBpreview(...)\fR               (see below for the details)
    \fBpreview-down\fR               \fIshift-down\fR
    \fBpreview-up\fR                 \fIshift-up\fR
    \fBpreview-page-down\fR
    \fBpreview-page-up\fR
    \fBpreview-half-page-down\fR
    \fBpreview-half-page-up\fR
    \fBpreview-bottom\fR
    \fBpreview-top\fR
    \fBprevious-history\fR           (\fIctrl-p\fR on \fB--history\fR)
    \fBprint-query\fR                (print query and exit)
    \fBput\fR                        (put the character to the prompt)
    \fBrefresh-preview\fR
    \fBrebind(...)\fR                (rebind bindings after \fBunbind\fR)
    \fBreload(...)\fR                (see below for the details)
    \fBreplace-query\fR              (replace query string with the current selection)
    \fBselect\fR
    \fBselect-all\fR                 (select all matches)
    \fBtoggle\fR                     (\fIright-click\fR)
    \fBtoggle-all\fR                 (toggle all matches)
    \fBtoggle+down\fR                \fIctrl-i  (tab)\fR
    \fBtoggle-in\fR                  (\fB--layout=reverse*\fR ? \fBtoggle+up\fR : \fBtoggle+down\fR)
    \fBtoggle-out\fR                 (\fB--layout=reverse*\fR ? \fBtoggle+down\fR : \fBtoggle+up\fR)
    \fBtoggle-preview\fR
    \fBtoggle-preview-wrap\fR
    \fBtoggle-search\fR              (toggle search functionality)
    \fBtoggle-sort\fR
    \fBtoggle+up\fR                  \fIbtab    (shift-tab)\fR
    \fBunbind(...)\fR                (unbind bindings)
    \fBunix-line-discard\fR          \fIctrl-u\fR
    \fBunix-word-rubout\fR           \fIctrl-w\fR
    \fBup\fR                         \fIctrl-k  ctrl-p  up\fR
    \fByank\fR                       \fIctrl-y\fR
