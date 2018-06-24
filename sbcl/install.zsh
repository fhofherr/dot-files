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
    echo "Minimal installation. Skipping SBCL"
    exit 0
fi

brew_install sbcl
apt_install sbcl

CURDIR=$PWD
SBCL_DIR="$DOTFILES_DIR/sbcl"

cd $SBCL_DIR
if [ ! -e "$HOME/quicklisp" ]
then
    curl -O https://beta.quicklisp.org/quicklisp.lisp
    sbcl --load "$SBCL_DIR/install.lisp"
fi
link_file "$SBCL_DIR/sbclrc" "$HOME/.sbclrc"
