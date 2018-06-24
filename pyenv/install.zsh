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
    echo "Minimal installation. Skipping Pyenv"
    exit 0
fi

brew_install pyenv pyenv-virtualenv
# Use manual installation for pyenv
if [[ "$OSTYPE" = linux* ]]
then
    PYENV_ROOT="$HOME/.pyenv"
    if [ ! -d "$PYENV_ROOT" ]
    then
        mkdir -p $PYENV_ROOT
    fi
    git_clone_or_pull https://github.com/pyenv/pyenv.git $PYENV_ROOT
fi
