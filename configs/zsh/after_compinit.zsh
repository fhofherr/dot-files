###
### pbpaste/pbcopy on linux
###

if command -v xclip > /dev/null 2>&1; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

if command -v xdg-open > /dev/null 2>&1; then
    alias open='xdg-open'
fi

###
### colors
###

function dotfiles_set_shell_colors {
    if [[ "$DOTFILES_COLOR_THEME" != 'base16-'* ]]; then
        return 0
    fi

    local fn_name
    fn_name="${DOTFILES_COLOR_THEME//base16-/base16_}"
    eval "$fn_name"
}
