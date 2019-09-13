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

    NEOVIM_VENV="$HOME/.neovim_venv"
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
    if ! _load_plugin_vim_python_config
    then
        return 1
    fi
    if [ ! -d "$NEOVIM_VENV" ]
    then
        ## Path to the system wide global python interpreter
        local global_python=$(command -v python3)
        $global_python -m venv $NEOVIM_VENV
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

# echo "Installing vim plugins"

if command -v nvim > /dev/null 2>&1
then

    if [ ! -f "$HOME/.local/dot-files/vim_installed" ]
    then
        printf "Install vim plugin dependencies? [y/N]: "
        if read -q; then
            echo
            _install_plugin_vim_python_dependencies
            _install_plugin_vim_nodejs_dependencies

            # Install all nvim plugins
            nvim -E -c 'PlugUpdate' -c 'qall!' > /dev/null

            mkdir -p "$HOME/.local/dot-files/"
            touch "$HOME/.local/dot-files/vim_installed"
        fi
    fi

    _load_plugin_vim_python_config
    _load_plugin_vim_nodejs_config

else
    echo "Could not find neovim. Please install it."
fi
