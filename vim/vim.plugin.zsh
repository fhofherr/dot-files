: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_NEOVIM_VENV=$HOME/.local/dotfiles/neovim_venv}
: ${DOTFILES_NEOVIM_NVR=$DOTFILES_NEOVIM_VENV/bin/nvr}
: ${DOTFILES_NEOVIM_PYTHON3=$DOTFILES_NEOVIM_VENV/bin/python}
: ${DOTFILES_NEOVIM_PIP=$DOTFILES_NEOVIM_VENV/bin/pip}

DOTFILES_NEOVIM_BINARY=$(command -v nvim 2> /dev/null)

function _dotfiles_make_vim_aliases {
    local vim_binary="$1"
    if [ -z "$vim_binary" ]; then
        vim_binary="$DOTFILES_NEOVIM_BINARY"
    fi

    alias nvim="$vim_binary"
    alias vim="$vim_binary"
    alias view="$vim_binary -R"
}

function _dotfiles_load_vim_python_config {
    if ! command -v python3 > /dev/null 2>&1
    then
        return 1
    fi
    export DOTFILES_NEOVIM_VENV
    export DOTFILES_NEOVIM_NVR
    export DOTFILES_NEOVIM_PYTHON3
    export DOTFILES_NEOVIM_PIP
}

function _dotfiles_install_vim_python_dependencies {
    if [ ! -d "$DOTFILES_NEOVIM_VENV" ]
    then
        mkdir -p $(dirname $DOTFILES_NEOVIM_VENV)
        ## Path to the system wide global python interpreter
        command python3 -m venv $DOTFILES_NEOVIM_VENV
    fi

    "$DOTFILES_NEOVIM_PIP" install --no-user --upgrade pip
    "$DOTFILES_NEOVIM_PIP" install --no-user --upgrade -r "$DOTFILES_DIR/vim/neovim_requirements.txt"
}

function _dotfiles_load_vim_config {
    _dotfiles_load_vim_python_config

    if [ -n "$NVIM_LISTEN_ADDRESS" ] && [ -x "$DOTFILES_NEOVIM_NVR" ]; then
        export EDITOR="$DOTFILES_NEOVIM_NVR"
        _dotfiles_make_vim_aliases "$DOTFILES_NEOVIM_NVR"
    else
        export EDITOR="$DOTFILES_NEOVIM_BINARY"
        _dotfiles_make_vim_aliases "$DOTFILES_NEOVIM_BINARY"
    fi
}

function _dotfiles_install_vim_dependencies {
    if [ -z "$XDG_CONFIG_HOME" ]
    then
        XDG_CONFIG_HOME="$HOME/.config"
    fi
    mkdir -p $XDG_CONFIG_HOME

    "$DOTFILES_DIR/bin/secure_link_file" "$DOTFILES_DIR/vim" "$HOME/.vim"
    "$DOTFILES_DIR/bin/secure_link_file" "$DOTFILES_DIR/vim/init.vim" "$HOME/.vimrc"
    "$DOTFILES_DIR/bin/secure_link_file" "$DOTFILES_DIR/vim" "$XDG_CONFIG_HOME/nvim"

    _dotfiles_install_vim_python_dependencies

    # Install all nvim plugins
    _dotfiles_load_vim_config
    echo "Installing vim plugins"
    if ! "$DOTFILES_NEOVIM_BINARY" -E -c 'PlugUpdate' -c 'qall!' > /dev/null 2>&1; then
        echo "Failed to install vim plugins"
    fi
}

# echo "Installing vim plugins"

if [ -n "$DOTFILES_NEOVIM_BINARY" ]; then
    if [ ! -d "$DOTFILES_NEOVIM_VENV" ]; then
        printf "Install vim plugin dependencies? [y/N]: "
        if read -q; then
            echo
            _dotfiles_install_vim_dependencies
        fi
    fi
    _dotfiles_load_vim_config
else
    echo "Could not find neovim. Please install it."
fi
