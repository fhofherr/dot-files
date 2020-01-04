#!/usr/bin/env zsh

: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_BIN_DIR:=$DOTFILES_DIR/bin}

if ! command -v git > /dev/null 2>&1; then
    echo "Git is not installed"
    return 1
fi

function _dotfiles_configure_git {
    "$DOTFILES_BIN_DIR/secure_link_file" "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"

    command git config --global core.excludesfile "$HOME/.gitignore_global"
}

if [ ! -e "$HOME/.gitignore_global" ]
then
    printf "Configure git plugin? [y/N]: "
    if read -q; then
        echo
        _dotfiles_configure_git
    fi
fi

export PATH="$DOTFILES_DIR/git/bin:$PATH"
