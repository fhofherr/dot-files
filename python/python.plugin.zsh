: ${DOTFILES_PYTHON_VENV:=$HOME/.local/dotfiles/python_venv}
: ${DOTFILES_PYTHON_BIN:=$DOTFILES_PYTHON_VENV/bin}
: ${DOTFILES_PYTHON_PIP:=$DOTFILES_PYTHON_BIN/pip}

function _install_python_plugin_dependencies {
    if [ -f "$HOME/.zsh_dotfiles_init" ]
    then
        source "$HOME/.zsh_dotfiles_init"
    else
        echo "Could not find '$HOME/.zsh_dotfiles_init'!"
        echo "Execute over-all install script!"
        return 1
    fi
    command mkdir -p $(dirname $DOTFILES_PYTHON_VENV)
    command python3 -m venv $DOTFILES_PYTHON_VENV

    $DOTFILES_PYTHON_PIP install --no-user --upgrade pip > /dev/null
    $DOTFILES_PYTHON_PIP install --no-user --upgrade -r $DOTFILES_DIR/python/python_requirements.txt > /dev/null
}

if command -v python3 > /dev/null 2>&1
then

    if [ ! -d "$DOTFILES_PYTHON_VENV" ]
    then
        printf "Install python plugin dependencies? [y/N]: "
        if read -q; then
            echo
            _install_python_plugin_dependencies
        fi
    fi

else
    echo "Could not find python. Please install it."
fi
