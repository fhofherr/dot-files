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
    echo "Minimal installation. Skipping ASDF"
    exit 0
fi

ASDF_VERSION="0.7.2"
PYTHON_VERSION="3.7.4"
NODEJS_VERSION="12.6.0"
GOLANG_VERSION="1.12.7"

git_clone_or_pull https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch "v$ASDF_VERSION"

if [ -d "$HOME/.asdf" ]; then
   source "$HOME/.asdf/asdf.sh"

   # Python is required by many neovim plugins
   asdf_install_global python $PYTHON_VERSION

   # Nodejs is required by a frew neovim plugin
   asdf_install_global nodejs $NODEJS_VERSION

   # I simply love go
   asdf_install_global golang $GOLANG_VERSION
fi

