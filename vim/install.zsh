#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi
source "$DOTFILES_DIR/lib/functions.zsh"
source "$DOTFILES_DIR/zsh/zshrc"

brew_install neovim the_silver_searcher
apt_install neovim silversearcher-ag

VIM=$(which nvim)
USE_NVIM=true
if [ -z "$VIM" ]
then
    VIM=$(which vim)
    USE_NVIM=false
    if [ -z "$VIM" ]
    then
        echo "Could not find nvim or vim"
        exit 1
    fi
fi

if [ -z "$XDG_CONFIG_HOME" ]
then
    XDG_CONFIG_HOME="$HOME/.config"
fi
mkdir -p $XDG_CONFIG_HOME

link_file "$DOTFILES_DIR/vim" "$HOME/.vim"
link_file "$DOTFILES_DIR/vim/init.vim" "$HOME/.vimrc"
link_file "$DOTFILES_DIR/vim" "$XDG_CONFIG_HOME/nvim"

GLOBAL_PYTHON=$(command -v python3)

if ! $DOTFILES_MINIMAL && $USE_NVIM && [ -n "$GLOBAL_PYTHON" ]
then
    NEOVIM_VENV="$HOME/.neovim_venv"
    $GLOBAL_PYTHON -m venv $NEOVIM_VENV

    # TODO necessary?
    #source $NEOVIM_VENV/bin/activate

    VENV_PYTHON=$NEOVIM_VENV/bin/python
    VENV_PIP=$NEOVIM_VENV/bin/pip

    # Install Python 3 Packages
    $VENV_PIP install --upgrade pip > /dev/null
    $VENV_PIP install --upgrade -r $DOTFILES_DIR/vim/neovim_requirements.txt > /dev/null
    NEOVIM_NVR=$NEOVIM_VENV/bin/nvr

    # export it as we start neovim farther down
    export NEOVIM_PYTHON3=$VENV_PYTHON
    if grep "NEOVIM_PYTHON3" "$HOME/.zsh_dotfiles_init" > /dev/null
    then
        sed -i'.bak' "s;export NEOVIM_PYTHON3=.*;export NEOVIM_PYTHON3=$NEOVIM_PYTHON3;g" $HOME/.zsh_dotfiles_init
    else
        echo "export NEOVIM_PYTHON3=$NEOVIM_PYTHON3" >> $HOME/.zsh_dotfiles_init
    fi

    if [ -n "$NEOVIM_NVR" ]
    then
        if grep "NEOVIM_NVR" "$HOME/.zsh_dotfiles_init" > /dev/null
        then
            sed -i'.bak' "s;export NEOVIM_NVR=.*;export NEOVIM_NVR=$NEOVIM_NVR;g" $HOME/.zsh_dotfiles_init
        else
            echo "export NEOVIM_NVR=$NEOVIM_NVR" >> $HOME/.zsh_dotfiles_init
        fi
    fi
fi

if which node > /dev/null && which npm > /dev/null
then
    NEOVIM_NPM=$(which npm)
fi
if ! $DOTFILES_MINIMAL && $USE_NVIM && [ -n "$NEOVIM_NPM" ]
then
    if [ -w "/usr/local/lib" ]
    then
        $NEOVIM_NPM install -g neovim
    else
        sudo $NEOVIM_NPM install -g neovim
    fi
    NEOVIM_NODE_HOST=$(which neovim-node-host)
    if grep "NEOVIM_NODE_HOST" "$HOME/.zsh_dotfiles_init" > /dev/null
    then
        sed -i'.bak' "s;export NEOVIM_NODE_HOST=.*;export NEOVIM_NODE_HOST=$NEOVIM_NODE_HOST;g" $HOME/.zsh_dotfiles_init
    else
        echo "export NEOVIM_NODE_HOST=$NEOVIM_NODE_HOST" >> $HOME/.zsh_dotfiles_init
    fi

    # ALE linters
    npm install -g markdownlint
fi

echo "Installing vim plugins"
$VIM -E -c 'PlugUpdate' -c 'qall!' > /dev/null
