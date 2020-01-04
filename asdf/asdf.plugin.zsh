: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_ASDF_REPO:=https://github.com/asdf-vm/asdf.git}
: ${DOTFILES_ASDF_HOME:=$HOME/.asdf}
: ${DOTFILES_USE_ASDF_DIRENV:=false}

DOTFILES_REQUIRED_ASDF_PLUGINS=(
        "python"
        "golang"
    )

if $DOTFILES_USE_ASDF_DIRENV; then
    DOTFILES_REQUIRED_ASDF_PLUGINS+="direnv"
fi

function _dotfiles_install_asdf {
    source "$DOTFILES_DIR/lib/functions.zsh"
    "$DOTFILES_DIR/git/bin/git-clone-or-pull" "$DOTFILES_ASDF_REPO" "$DOTFILES_ASDF_HOME"

    local curdir="$PWD"
    cd "$DOTFILES_ASDF_HOME"
    command git checkout "$(git describe --abbrev=0 --tags)"
    cd "$curdir"
}

function _dotfiles_install_required_asdf_plugins {
    local plugin
    for plugin in $DOTFILES_REQUIRED_ASDF_PLUGINS; do
        "$DOTFILES_ASDF_HOME/bin/asdf" plugin add "$plugin"
    done
}

if [ ! -d "$DOTFILES_ASDF_HOME" ]
then
    printf "Install asdf plugin dependencies? [y/N]: "
    if read -q; then
        echo
        _dotfiles_install_asdf
        _dotfiles_install_required_asdf_plugins
    fi
fi

if $DOTFILES_USE_ASDF_DIRENV; then
    export PATH="$DOTFILES_ASDF_HOME/bin:$PATH"
else
    if [ -d "$DOTFILES_ASDF_HOME" ]; then
        source "$DOTFILES_ASDF_HOME/asdf.sh"
        source "$DOTFILES_ASDF_HOME/completions/asdf.bash"
    fi
fi
