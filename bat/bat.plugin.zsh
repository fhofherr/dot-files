: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_BIN_DIR:=$DOTFILES_DIR/bin}

DOTFILES_BAT="$(command -v bat 2> /dev/null)"
if [ -z "$DOTFILES_BAT" ]; then
    return 1
fi
DOTFILES_BAT_CONFIG_DIR="$("$DOTFILES_BAT" --config-dir)"

function _dotfiles_bat_configure {
    mkdir -p "$DOTFILES_BAT_CONFIG_DIR"
    "$DOTFILES_BIN_DIR/secure_link_file" "$DOTFILES_DIR/bat/config" "$("$DOTFILES_BAT" --config-file)"
    "$DOTFILES_BAT" cache --build
}

if [ ! -d "$DOTFILES_BAT_CONFIG_DIR" ]
then
    printf "Configure bat? [y/N]: "
    if read -q; then
        echo
        _dotfiles_bat_configure
    fi
fi

