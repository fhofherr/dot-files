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
    echo "Minimal installation. Skipping Clojure"
    exit 0
fi

brew_install clojure
# TODO Ubuntu

CLOJURE_HOME="$HOME/.clojure"
mkdir -p $CLOJURE_HOME
link_file "$DOTFILES_DIR/clojure/deps.edn" "$CLOJURE_HOME/deps.edn"
