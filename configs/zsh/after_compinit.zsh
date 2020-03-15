###
### FZF
###

if [ -f "$HOME/.fzf.zsh" ]; then
   source "$HOME/.fzf.zsh"

   # Re-bind the fzf-file-widget from ^T to ^P. This makes it work just like
   # in my vim configuration.
   bindkey '^P' fzf-file-widget

   if command -v bat > /dev/null 2>&1
   then
       export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers,changes  --line-range=:15 --color always {} 2> /dev/null'"
   fi
fi

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

    fn_name="${DOTFILES_COLOR_THEME//base16-/base16_}-${DOTFILES_COLOR_PROFILE}"
    "$fn_name"
}
