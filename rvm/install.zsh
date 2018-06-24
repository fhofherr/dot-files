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
    echo "Minimal installation. Skipping RVM"
    exit 0
fi

RVM_DIR="$HOME/.rvm"

if [ ! -e "$RVM_DIR" ]
then
    if command -v gpg > /dev/null
    then
        gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB > /dev/null 2>&1
    fi
    curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles stable > /dev/null 2>&1
fi

if ! command -v rvm > /dev/null
then
    source $RVM_DIR/scripts/rvm
fi

rvm get stable > /dev/null 2>&1
