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
    echo "Minimal installation. Skipping Go"
    exit 0
fi

function install_go() {
    local version="$1"
    local os="$2"
    local arch="$3"
    local pkg="go$version.$os-$arch.tar.gz"
    curl https://dl.google.com/go/$pkg -o /tmp/$pkg
    sudo tar -C /usr/local -xzf /tmp/$pkg
}

brew_install go
if [[ "$OSTYPE" = linux* ]] && ! command -v go > /dev/null
then
    install_go "1.10.3" "linux" "amd64"
fi
