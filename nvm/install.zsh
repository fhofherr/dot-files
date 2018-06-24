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

NVM_VERSION="v0.33.11"

if $DOTFILES_MINIMAL
then
    echo "Minimal installation. Skipping NVM"
    exit 0
fi

if [ -z "$NVM_DIR" ]
then
    NVM_DIR="$HOME/.nvm"
fi

if [ ! -e "$NVM_DIR" ]
then
    curl -o- "https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh" | bash
else
    curdir=$PWD
    cd $NVM_DIR
    git fetch --tags origin
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    cd $curdir
fi

if ! command -v nvm > /dev/null
then
    source $NVM_DIR/nvm.sh
fi
