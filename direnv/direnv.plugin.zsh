# See https://direnv.net/

: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_BIN_DIR:=$DOTFILES_DIR/bin}
: ${DOTFILES_ASDF_HOME:=$HOME/.asdf}
: ${DOTFILES_USE_ASDF_DIRENV:=false}

: ${XDG_CONFIG_HOME:=$HOME/.config}

DOTFILES_DIRENV_CONFIG_FILE="$XDG_CONFIG_HOME/direnv/direnvrc"

function _dotfiles_install_asdf_direnv {
    local latest_direnv_version

    latest_direnv_version="$($DOTFILES_ASDF_HOME/bin/asdf list-all direnv | tail -n1)"

    if [ -z "$latest_direnv_version" ]; then
        echo "Could not determine latest direnv version"
        return 1
    fi
    "$DOTFILES_ASDF_HOME/bin/asdf" install direnv "$latest_direnv_version"
    "$DOTFILES_ASDF_HOME/bin/asdf" global direnv "$latest_direnv_version"
    alias direnv="$DOTFILES_ASDF_HOME/bin/asdf exec direnv"
}

function _dotfiles_install_direnv {
    mkdir -p "$(dirname $DOTFILES_DIRENV_CONFIG_FILE)"
    "$DOTFILES_BIN_DIR/secure_link_file" "$DOTFILES_DIR/direnv/direnvrc" "$DOTFILES_DIRENV_CONFIG_FILE"

    if ! command -v direnv > /dev/null 2>&1 && ! $DOTFILES_USE_ASDF_DIRENV; then
        echo "Please install direnv manually"
        return 0
    fi

    echo "Using asdf to install direnv"
    _dotfiles_install_asdf_direnv
}

if ! command -v direnv > /dev/null 2>&1 && ! "$DOTFILES_ASDF_HOME/bin/asdf" which direnv > /dev/null; then
    printf "Install direnv plugin dependencies? [y/N]: "
    if read -q; then
        echo
        _dotfiles_install_direnv
    fi

fi

if $DOTFILES_USE_ASDF_DIRENV && "$DOTFILES_ASDF_HOME/bin/asdf" which direnv > /dev/null 2>&1; then
    eval "$($DOTFILES_ASDF_HOME/bin/asdf exec direnv hook zsh)"
elif command -v direnv > /dev/null 2>&1; then
    eval "$(direnv hook zsh)"
else
    echo "direnv is not installed"
    return 1
fi
