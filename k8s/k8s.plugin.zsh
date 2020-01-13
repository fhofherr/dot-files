DOTFILES_KUBECTL="$(command -v kubectl 2> /dev/null)"
if [ -z "$DOTFILES_KUBECTL" ]; then
    return 1
fi

eval "$($DOTFILES_KUBECTL completion zsh)"
alias k="$DOTFILES_KUBECTL"
