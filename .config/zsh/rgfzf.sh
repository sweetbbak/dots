# RipGrep MAN page:
# https://www.mankier.com/1/rg

# Core helper function.
# Add -s for --case-sensitive search when calling the top level functions.
# rp "LoginView" -s
# For --colors, see https://www.mankier.com/1/rg#--colors.

_rg() {
    rg \
        --ignore-case \
        --colors path:fg:175,135,255 \
        --colors line:fg:red \
        --colors match:fg:green \
        --colors match:style:nobold $@
}


# rg-python
# Search in Python files only.
rp() {
    _rg --type py --glob '!**/tests/**' --glob '!**/migrations/**' $@
}

# rg-python-all
# Search in Python files only, including those ignored files.
# Useful for scouring the `site-packages` or Django source code.
rpa() {
    rp --no-ignore $@
}

# rg-python-tests
# Search in unit test files.
rpt() {
    rp --glob '**/tests/**' $@
}

# rg-python-migrations
# Search in migration files.
rpm() {
    rp --glob '**/migrations/**' $@
}

# rg-python-html
# Search in Python + HTML files.
rph() {
    rp --type html $@
}

# rg-python-html-js
# Search in Python + HTML + JS files.
rphj() {
    rph --type js --glob '!*.min.js' $@
}


# rg-html
# Search in HTML files only.
rh() {
    _rg --type html $@
}

# rg-html-js
# Search in HTML + JS files.
rhj() {
    rh --type js --glob '!*.min.js' $@
}

# rg-html-js-css
# Search in HTML + JS + CSS files.
rhjc() {
    rhj --type css --glob '!*.min.js' $@
}

# rg-js
# Search in JS files only. Exclude minified files.
rj() {
    _rg --type js --glob '!*.min.js' $@
}

# rg-css
# Search in CSS files only.
rc() {
    _rg --type css $@
}

# rg-txt
# Search in text files (mainly Python's requirements.txt).
rt() {
    _rg --type txt $@
}

# rg-yaml
# Search in YAML files (mainly CI/k8s files).
ry() {
    _rg --type yaml $@
}


# rg-all
# Include the Git-ignored files w/c are excluded by default!
# Exclude files we don't care about.
# Define file type if it's not included in the `rg --type-list`.
ra() {
    _rg \
        --no-ignore \
        --type-add 'compiled:*.compiled' \
        --type-not compiled \
        --type-not log \
        $@
}

# rg-git-conflicts
# Search for Git conflict marker in important files.
# No need to search all file types.
# rgc instead of `rc` since it's already mapped to CSS files.
rcc() {
    _rg \
        --type py \
        --type html \
        --type js \
        --type css \
        --type yaml \
        --type txt \
        --type po \
        --type md \
        '>>>>>>>'
}


# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setting fd as the default source for fzf
# This is used when running `fzf` in the CLI.
# For faster/better results with ** operator in files/folders,
# preprend with a representative folder first, like
# `cd projects/**` instead of `cd **` only.
export FZF_DEFAULT_COMMAND='
    fd \
        --hidden \
        --follow \
        --no-ignore \
        --exclude node_modules \
        --exclude Library \
        --exclude logs \
        --exclude /media \
        --exclude /static \
        --exclude /sites \
        --exclude cache \
        --exclude undo/ \
        --exclude backups/ \
        --exclude automatic_backups/ \
        --exclude autoload/ \
        --exclude .idea/ \
        --exclude .git \
        --exclude .DS_Store \
        --exclude .git \
        --exclude "*.pyc" \
        --exclude "*.compiled" \
        --exclude "*.scss" \
'

export FZF_PREVIEW_COMMAND='COLORTERM=truecolor bat --style=numbers --color=always --line-range :5000 {}'

# Set the FZF color scheme.
# https://github.com/junegunn/fzf/wiki/Color-schemes
# https://minsw.github.io/fzf-color-picker/
# https://github.com/base16-project/base16-fzf/blob/main/bash/base16-onedark.config

local color00='#282c34'
local color01='#353b45'
local color02='#3e4451'
local color03='#545862'
local color04='#565c64'
local color05='#abb2bf'
local color06='#b6bdca'
local color07='#c8ccd4'
local color08='#e06c75'
local color09='#d19a66'
local color0A='#e5c07b'
local color0B='#98c379'
local color0C='#56b6c2'
local color0D='#61afef'
local color0E='#c678dd'
local color0F='#be5046'
local dracula_green='#5fff87'
local dracula_magenta='#ff87d7'
local dracula_purple='#af87ff'
local dracula_yellow='#ffaf5f'

export FZF_DEFAULT_OPTS="
    --multi
    --bind ctrl-a:toggle-all
    --color=fg:$color04,header:$color0B,info:$dracula_purple,pointer:$dracula_green
    --color=bg+:$color01,bg:$color00,spinner:$dracula_green,hl:$color0B
    --color=marker:$dracula_green,fg+:$color06,prompt:$dracula_green,hl+:$color0B,query:$dracula_magenta
"

rfb() {
    # --nth=3 to search the right side of each line which is the code contents.
    rg  --line-number --no-heading '' | fzf --delimiter=: --preview "$HOME/Desktop/fzf-bat-preview.sh {1} {2}" --nth=3
}

rpfb() {
    # --nth=3 to search the right side of each line which is the code contents.
    rp  --line-number --no-heading '' | fzf --delimiter=: --preview "$HOME/Desktop/fzf-bat-preview.sh {1} {2}" --nth=3
}


# `bat`
# https://github.com/sharkdp/bat
export BAT_THEME="TwoDark"


# Activate auto-completion and keybindings like Ctrl-R.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
