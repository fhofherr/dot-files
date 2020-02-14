#!/usr/bin/env zsh

: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_BIN_DIR:=$DOTFILES_DIR/bin}

: ${DOTFILES_DBCLI_VENV:=$HOME/.local/dotfiles/dbcli_venv}
: ${DOTFILES_DBCLI_BIN:=$DOTFILES_DBCLI_VENV/bin}
: ${DOTFILES_DBCLI_PIP:=$DOTFILES_DBCLI_BIN/pip}

function _dotfiles_dbcli_install {
    if ! command -v pg_config > /dev/null 2>&1; then
        echo "pg_config needs to be installed"
        echo "on fedora: dnf install libpqxx-devel"
        return 1
    fi
    command mkdir -p "$(dirname $DOTFILES_DBCLI_VENV)"
    command python3 -m venv "$DOTFILES_DBCLI_VENV"

    "$DOTFILES_DBCLI_PIP" install --no-user --upgrade pip
    "$DOTFILES_DBCLI_PIP" install --no-user --upgrade -r "$DOTFILES_DIR/dbcli/requirements.txt"
}

if [ ! -e "$DOTFILES_DBCLI_VENV" ]
then
    printf "Install dbcli? [y/N]: "
    if read -q; then
        echo
        _dotfiles_dbcli_install
    fi
fi

if [ -d "$DOTFILES_DBCLI_BIN" ]; then
    export PATH="$DOTFILES_DBCLI_BIN:$PATH"
fi
