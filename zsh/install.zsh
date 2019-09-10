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

DRACULA_ZSH_THEME="https://github.com/dracula/zsh.git"
git_clone_or_pull $DRACULA_ZSH_THEME "$ZSH_CUSTOM/themes/dracula"
git_clone_or_pull "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git_clone_or_pull "https://github.com/wfxr/forgit" "$ZSH_CUSTOM/plugins/forgit"
link_file "$ZSH_CUSTOM/themes/dracula/dracula.zsh-theme" "$ZSH/themes/dracula.zsh-theme"
