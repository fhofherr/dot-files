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

brew_install zsh
apt_install zsh

OH_MY_ZSH_REPO="https://github.com/robbyrussell/oh-my-zsh.git"
git_clone_or_pull $OH_MY_ZSH_REPO $ZSH

link_file "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
link_file "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

if [ -z "$ZSH_CUSTOM" ]
then
    source "$HOME/.zshrc"
fi

# Download and install additional zsh plugins
ZSH_NVM_REPO="https://github.com/lukechilds/zsh-nvm"
ZSH_NVM_DIR="$ZSH_CUSTOM/plugins/zsh-nvm"
git_clone_or_pull $ZSH_NVM_REPO $ZSH_NVM_DIR
