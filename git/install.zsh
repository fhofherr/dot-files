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

# OS X: use the git that comes with Xcode
apt_install git

if [ ! -e "$HOME/.gitignore_global" ]
then
    ln -s "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"
else
    echo "$HOME/.gitignore_global exists"
fi

git config --global core.excludesfile "$HOME/.gitignore_global"
