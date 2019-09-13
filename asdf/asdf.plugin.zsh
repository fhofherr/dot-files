#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi

function _install_plugin_asdf_dependencies {
    source "$DOTFILES_DIR/lib/functions.zsh"
    git_clone_or_pull https://github.com/asdf-vm/asdf.git $HOME/.asdf

    local curdir=$PWD
    cd $HOME/.asdf
    git checkout "$(git describe --abbrev=0 --tags)"
    cd $curdir
}

if [ ! -d "$HOME/.asdf" ]
then
    printf "Install asdf plugin dependencies? [y/N]: "
    if read -q; then
        echo
        _install_plugin_asdf_dependencies
    fi
fi

if [ -d "$HOME/.asdf" ]; then
   source "$HOME/.asdf/asdf.sh"
   source "$HOME/.asdf/completions/asdf.bash"
fi
