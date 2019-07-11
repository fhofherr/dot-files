#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi
source "$DOTFILES_DIR/lib/functions.zsh"

if $DOTFILES_MINIMAL
then
    echo "Minimal installation. Skipping ASDF"
    exit 0
fi

ASDF_VERSION="0.7.2"

git_clone_or_pull https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch "v$ASDF_VERSION"
