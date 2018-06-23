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


if ! $DOTFILES_MINIMAL && $USE_NVIM && command -v pyenv > /dev/null
then
    NEOVIM_PYTHON3_VERSION="3.6.5"
    NEOVIM_PYTHON3_VENV="neovim-py3-venv"

    NEOVIM_PYTHON2_VERSION="2.7.15"
    NEOVIM_PYTHON2_VENV="neovim-py2-venv"

    eval "$(pyenv init - zsh)"
    eval "$(pyenv virtualenv-init - zsh)"

    if ! pyenv versions | grep "$NEOVIM_PYTHON3_VERSION" > /dev/null
    then
        pyenv install "$NEOVIM_PYTHON3_VERSION" > /dev/null
    fi

    if ! pyenv versions | grep "$NEOVIM_PYTHON2_VERSION" > /dev/null
    then
        pyenv install "$NEOVIM_PYTHON2_VERSION" > /dev/null
    fi

    if ! pyenv virtualenvs | grep "$NEOVIM_PYTHON3_VENV" > /dev/null
    then
        pyenv virtualenv "$NEOVIM_PYTHON3_VERSION" "$NEOVIM_PYTHON3_VENV" > /dev/null
    fi

    if ! pyenv virtualenvs | grep "$NEOVIM_PYTHON2_VENV" > /dev/null
    then
        pyenv virtualenv "$NEOVIM_PYTHON2_VERSION" "$NEOVIM_PYTHON2_VENV" > /dev/null
    fi

    # Install Python 3 Packages
    pyenv activate "$NEOVIM_PYTHON3_VENV" > /dev/null 2>&1
    NEOVIM_PYTHON3=$(pyenv which python)
    NEOVIM_PIP3=$(pyenv which pip)
    $NEOVIM_PIP3 install --upgrade pip > /dev/null
    $NEOVIM_PIP3 install --upgrade -r $DOTFILES_DIR/vim/neovim_requirements.txt > /dev/null
    pyenv deactivate > /dev/null

    # Install Python 2 Packages
    pyenv activate "$NEOVIM_PYTHON2_VENV" > /dev/null 2>&1
    NEOVIM_PYTHON2=$(pyenv which python)
    NEOVIM_PIP2=$(pyenv which pip)
    $NEOVIM_PIP2 install --upgrade pip > /dev/null
    $NEOVIM_PIP3 install --upgrade -r $DOTFILES_DIR/vim/neovim_requirements.txt > /dev/null
    pyenv deactivate > /dev/null

    if grep "$NEOVIM_PYTHON3" "$HOME/.zsh_dotfiles_init" > /dev/null
    then
        sed -i'.bak' "s;export NEOVIM_PYTHON3=.*;export NEOVIM_PYTHON3=$NEOVIM_PYTHON3;g" $HOME/.zsh_dotfiles_init
    else
        echo "export NEOVIM_PYTHON3=$NEOVIM_PYTHON3" >> $HOME/.zsh_dotfiles_init
    fi
    if grep "$NEOVIM_PYTHON2" "$HOME/.zsh_dotfiles_init" > /dev/null
    then
        sed -i'.bak' "s;export NEOVIM_PYTHON2=.*;export NEOVIM_PYTHON2=$NEOVIM_PYTHON2;g" $HOME/.zsh_dotfiles_init
    else
        echo "export NEOVIM_PYTHON2=$NEOVIM_PYTHON2" >> $HOME/.zsh_dotfiles_init
    fi
fi

if which /usr/local/bin/gem > /dev/null
then
    GEM="/usr/local/bin/gem"
fi

if which /usr/local/bin/npm > /dev/null
then
    NPM="/usr/local/bin/npm"
fi

if $USE_NVIM
then
    if [ -n "$GEM" ]
    then
        $GEM install neovim
    fi

    if [ -n "$NPM" ]
    then
        $NPM install -g neovim
    fi
fi

if [ ! -e "$DOTFILES_DIR/vim/local.vim" ]; then
    cp "$DOTFILES_DIR/vim/local.vim.template" "$DOTFILES_DIR/vim/local.vim"
fi

echo "Installing vim plugins"
$VIM -E -c 'PlugUpdate' -c 'qall!' > /dev/null

echo "Installing ale linters"
if [ -n "$GEM" ]
then
    $GEM install mdl
fi

if [ -n "$NPM" ]
then
    $NPM install -g markdownlint
fi

if [ -n "$PIP3" ]
then
    $PIP3 install --upgrade gitlint
fi

if [ -n "$PIP2" ]
then
    $PIP2 install --upgrade gitlint
fi

if [ -n "$PIP" ]
then
    $PIP install --upgrade gitlint
fi
