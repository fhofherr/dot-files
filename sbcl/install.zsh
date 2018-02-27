#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi

CURDIR=$PWD
SBCL_DIR="$DOTFILES_DIR/sbcl"

cd $SBCL_DIR
if [ ! -e "$HOME/quicklisp" ]
then
    curl -O https://beta.quicklisp.org/quicklisp.lisp
    sbcl --load "$SBCL_DIR/install.lisp"
fi

if [ -e "$HOME/.sbclrc" ]
then
    echo "$HOME/.sbclrc exists"
else
    ln -s "$SBCL_DIR/sbclrc" "$HOME/.sbclrc"
fi
