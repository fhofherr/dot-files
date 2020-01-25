: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_PLATFORMIO_VENV:=$HOME/.platformio/penv}
: ${DOTFILES_PLATFORMIO_BIN:=$DOTFILES_PLATFORMIO_VENV/bin}
: ${DOTFILES_PLATFORMIO_PIP:=$DOTFILES_PLATFORMIO_BIN/pip}
: ${DOTFILES_PLATFORMIO_PROJECTS_DIR:=$HOME/Projects}

function _dotfiles_install_platformio {
    command mkdir -p "$(dirname $DOTFILES_PLATFORMIO_VENV)"
    command python3 -m venv "$DOTFILES_PLATFORMIO_VENV"

    command "$DOTFILES_PLATFORMIO_PIP" install --upgrade pip
    command "$DOTFILES_PLATFORMIO_PIP" install --upgrade platformio
}

function _dotfiles_configure_platformio {
    if ! command -v pio > /dev/null 2>&1
    then
        echo "PlatformIO is not intalled"
    fi
    command pio settings set projects_dir "$DOTFILES_PLATFORMIO_PROJECTS_DIR"
}

if [ ! -d "$DOTFILES_PLATFORMIO_VENV" ]
then
    printf "Install platformio? [y/N]: "
    if read -q; then
        echo
        _dotfiles_install_platformio
    fi
fi

if [ -d "$DOTFILES_PLATFORMIO_BIN" ]
then
    export PATH="$DOTFILES_PLATFORMIO_BIN:$PATH"
fi
