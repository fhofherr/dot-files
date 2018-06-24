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
    echo "Minimal installation. Skipping Jabba"
    exit 0
fi

# Installs or upgrades
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash
