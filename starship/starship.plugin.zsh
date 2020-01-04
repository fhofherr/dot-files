# vim: set ft=zsh:

# See https://github.com/starship/starship
# See https://starship.rs

: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${DOTFILES_LOCAL_BIN_DIR:=$HOME/bin}

DOTFILES_STARSHIP_BINARY="$DOTFILES_LOCAL_BIN_DIR/starship"

function _install_starship_binary {
    local tmpdir tarfile sumfile

    tmpdir="/tmp/$USER/dotfiles_starship"
    tarfile="$tmpdir/starship.tar.gz"
    sumfile="$tmpdir/starship.sha256"

    rm -rf "$tmpdir"
    mkdir -p "$tmpdir"

    case "$OSTYPE" in
        linux-gnu)
            curl -fsSL "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz" --output "$tarfile"
            curl -fsSL "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz.sha256" --output "$sumfile"
            ;;
        *)
            echo "Unsupported ostype: $OSTYPE"
            rm -rf "$tmpdir"
            return 1
    esac

    if ! echo "$(cat $sumfile) $tarfile" | sha256sum --check --status
    then
        echo "sha256sum of downloaded file does not match"
        rm -rf "$tmpdir"
        return 1
    fi

    local curdir
    curdir="$PWD"

    cd "$tmpdir"
    tar xzvf "$tarfile"
    mkdir -p "$DOTFILES_LOCAL_BIN_DIR"
    cp "$tmpdir/starship" "$DOTFILES_STARSHIP_BINARY"

    cd "$curdir"
    rm -rf "$tmpdir"
}

function _link_starship_config {
    mkdir -p "$XDG_CONFIG_HOME"
    link_file "$DOTFILES_DIR/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
}

function _install_starship {
    if [ -f "$HOME/.zsh_dotfiles_init" ]
    then
        source "$HOME/.zsh_dotfiles_init"
        source "$DOTFILES_DIR/lib/functions.zsh"
    else
        echo "Could not find '$HOME/.zsh_dotfiles_init'!"
        echo "Execute over-all install script!"
        return 1
    fi

    _install_starship_binary
    _link_starship_config
}

if [ ! -f "$DOTFILES_STARSHIP_BINARY" ]; then
    printf "Install starship binary? [y/N]: "
    if read -q; then
        echo
        _install_starship
    fi
fi

if [ -x "$DOTFILES_STARSHIP_BINARY" ]; then
    eval "$($DOTFILES_STARSHIP_BINARY init zsh)"
fi
