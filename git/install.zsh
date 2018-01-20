#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi

if [ ! -e "$HOME/.gitignore_global" ]
then
    ln -s "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"
else
    echo "$HOME/.gitignore_global exists"
fi

git config --global core.excludesfile "$HOME/.gitignore_global"
