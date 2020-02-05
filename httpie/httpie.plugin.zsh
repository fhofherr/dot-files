: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_HTTPIE_VENV:=$HOME/.local/dotfiles/httpie_venv}
: ${DOTFILES_HTTPIE_BIN:=$DOTFILES_HTTPIE_VENV/bin}
: ${DOTFILES_HTTPIE_PIP:=$DOTFILES_HTTPIE_BIN/pip}

function _dotfiles_install_httpie {
    command mkdir -p $(dirname $DOTFILES_HTTPIE_VENV)
    command python3 -m venv $DOTFILES_HTTPIE_VENV

    $DOTFILES_HTTPIE_PIP install --no-user --upgrade pip
    $DOTFILES_HTTPIE_PIP install --no-user --upgrade -r $DOTFILES_DIR/httpie/requirements.txt
}

if command -v python3 > /dev/null 2>&1
then

    if [ ! -d "$DOTFILES_HTTPIE_VENV" ]
    then
        printf "Install httpie plugin dependencies? [y/N]: "
        if read -q; then
            echo
            _dotfiles_install_httpie
        fi
    fi
    export DOTFILES_HTTPIE_VENV
    export DOTFILES_HTTPIE_BIN
    export PATH="$DOTFILES_HTTPIE_BIN:$PATH"

else
    echo "Could not find python. Please install it."
fi
