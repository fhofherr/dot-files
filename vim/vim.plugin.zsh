if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
    source "$DOTFILES_DIR/lib/functions.zsh"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
fi

function _load_plugin_vim_python_config {
    if ! command -v python3 > /dev/null 2>&1
    then
        return 1
    fi

    NEOVIM_VENV="$HOME/.local/dotfiles/neovim_venv"
    NEOVIM_NVR="$NEOVIM_VENV/bin/nvr"
    NEOVIM_PYTHON3="$NEOVIM_VENV/bin/python"
    NEOVIM_PIP="$NEOVIM_VENV/bin/pip"

    if [ -d "$NEOVIM_VENV" ]
    then
        export NEOVIM_VENV
        export NEOVIM_NVR
        export NEOVIM_PYTHON3
        export NEOVIM_PIP
    fi
}

function _load_plugin_vim_nodejs_config {
    if ! command -v neovim-node-host > /dev/null 2>&1
    then
        return 1
    fi
    export NEOVIM_NODE_HOST=$(command -v neovim-node-host)
}


function _install_plugin_vim_nodejs_dependencies {
    if ! command -v npm > /dev/null 2>&1
    then
        return 1
    fi
    if ! _load_plugin_vim_nodejs_config
    then
        npm install -g neovim
        npm install -g markdownlint
    fi
    return _load_plugin_vim_nodejs_config
}

function _install_plugin_vim_python_dependencies {
    if [ ! -d "$NEOVIM_VENV" ]
    then
        mkdir -p $(dirname $NEOVIM_VENV)
        ## Path to the system wide global python interpreter
        command python3 -m venv $NEOVIM_VENV
    fi

    $NEOVIM_PIP install --no-user --upgrade pip > /dev/null
    $NEOVIM_PIP install --no-user --upgrade -r $DOTFILES_DIR/vim/neovim_requirements.txt > /dev/null
}

function _install_plugin_vim {
    if [ -z "$XDG_CONFIG_HOME" ]
    then
        XDG_CONFIG_HOME="$HOME/.config"
    fi
    mkdir -p $XDG_CONFIG_HOME

    link_file "$DOTFILES_DIR/vim" "$HOME/.vim"
    link_file "$DOTFILES_DIR/vim/init.vim" "$HOME/.vimrc"
    link_file "$DOTFILES_DIR/vim" "$XDG_CONFIG_HOME/nvim"

    _install_plugin_vim_python_dependencies
}

function _make_vim_plugin_aliases {
    if [ -n "$NVIM_LISTEN_ADDRESS" ]
    then
        if [ -n "$NEOVIM_NVR" ]
        then
            alias nvim="$NEOVIM_NVR -p"
            alias nvr="$NEOVIM_NVR"
        else
            echo "Don't nest neovim!"
        fi
    fi
    alias e="nvim"
    alias vim="nvim"
    alias view="nvim -R"
}

# echo "Installing vim plugins"

if command -v nvim > /dev/null 2>&1
then

    if _load_plugin_vim_python_config && [ ! -d "$NEOVIM_VENV" ]
    then
        printf "Install vim plugin dependencies? [y/N]: "
        if read -q; then
            echo
            _install_plugin_vim_python_dependencies
            _install_plugin_vim_nodejs_dependencies

            # Install all nvim plugins
            command nvim -E -c 'PlugUpdate' -c 'qall!' > /dev/null
        fi
    else
        _load_plugin_vim_nodejs_config
        _make_vim_plugin_aliases
    fi

else
    echo "Could not find neovim. Please install it."
fi