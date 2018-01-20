#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi

TPM_REMOTE_REPO="https://github.com/tmux-plugins/tpm"

TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"
mkdir -p $TMUX_PLUGIN_DIR

if [ ! -e "$TMUX_PLUGIN_DIR/tpm" ]
then
    git clone $TPM_REMOTE_REPO "$TMUX_PLUGIN_DIR/tpm" > /dev/null
elif [ -d "$TMUX_PLUGIN_DIR/tpm" ]
then
    curdir=$PWD
    cd "$TMUX_PLUGIN_DIR/tpm"
    git pull > /dev/null
    cd "$curdir"
else
    echo "$TMUX_PLUGIN_DIR/tpm exists but is not a directory"
fi

if [ ! -e "$HOME/.tmux.conf" ]
then
    ln -s "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
else
    echo "$HOME/.tmux.conf exists"
fi

if [ ! -e "$HOME/.tmuxline-snapshot.conf" ]
then
    ln -s "$DOTFILES_DIR/tmux/tmuxline-snapshot.conf" "$HOME/.tmuxline-snapshot.conf"
else
    echo "$HOME/tmuxline-snapshot.conf exists"
fi

if ! infocmp tmux-256color > /dev/null 2>&1
then
    echo "Creating tmux terminfo entries"
    tic -x $DOTFILES_DIR/tmux/tmux.terminfo
fi

tmux new-session -s tmux-install -d
tmux run-shell /Users/fh/.tmux/plugins/tpm/bindings/install_plugins
tmux kill-session -t tmux-install
