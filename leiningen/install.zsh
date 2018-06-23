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

if [ $DOTFILES_MINIMAL ]
then
    echo "Minimal installation. Skipping Leiningen"
    exit 0
fi

brew_install leiningen
# TODO ubuntu

LEIN_HOME="$HOME/.lein"
mkdir -p $LEIN_HOME
link_file "$DOTFILES_DIR/leiningen/profiles.clj" "$LEIN_HOME/profiles.clj"
