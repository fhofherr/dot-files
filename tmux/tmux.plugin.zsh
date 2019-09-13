#!/usr/bin/env zsh

function _install_tmux_plugin_dependencies {
    if [ -f "$HOME/.zsh_dotfiles_init" ]
    then
        source "$HOME/.zsh_dotfiles_init"
    else
        echo "Could not find '$HOME/.zsh_dotfiles_init'!"
        echo "Execute over-all install script!"
    fi
    source "$DOTFILES_DIR/lib/functions.zsh"

    local tmux_plugin_dir="$HOME/.tmux/plugins"
    local tpm_remote_repo="https://github.com/tmux-plugins/tpm"
    mkdir -p "$tmux_plugin_dir"
    git_clone_or_pull "$tpm_remote_repo" "$tmux_plugin_dir/tpm"

    link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    if ! infocmp tmux-256color > /dev/null 2>&1
    then
        echo "Creating tmux terminfo entries"
        tic -x $DOTFILES_DIR/tmux/tmux.terminfo
    fi

    tmux new-session -s tmux-install -d
    tmux run-shell $HOME/.tmux/plugins/tpm/bindings/install_plugins
    tmux kill-session -t tmux-install
}

function _tmux_new_session {
    if [ -z "$1" ]
    then
        local session_name="default"
    else
        local session_name="$1"
    fi
    if [ -z "$TMUX" ]
    then
        TERM=tmux-256color tmux new-session -s $session_name
    else
        TERM=tmux-256color tmux new-session -s $session_name -d
        TERM=tmux-256color tmux switch-client -t $session_name
    fi
}

function _tmux_new_project_session {
    local session_name=$(basename $PWD)

    TERM=tmux-256color tmux new-session -s $session_name -d
    TERM=tmux-256color tmux switch-client -t $session_name > /dev/null 2>&1
}

function _make_tmux_plugin_aliases {
    # Some ssh sessions run into trouble if TERM is set to tmux-256color
    alias ssh='TERM=xterm-color ssh'

    alias tmux="TERM=tmux-256color tmux"
    alias tls="tmux ls"
    alias tns="_tmux_new_session"
    alias tks="tmux kill-session -t"
    alias tnsp="_tmux_new_project_session"
    alias tnsd="tmux new-session -d -s"
    alias tnw="tmux new-window"
    alias tss="tmux switch-client -t"
    alias tas="tmux attach -t"
}

if command -v tmux > /dev/null 2>&1
then
    if [ ! -f "$HOME/.tmux.conf" ]
    then
        printf "Install vim plugin dependencies? [y/N]: "
        if read -q; then
            echo
            _install_tmux_plugin_dependencies
        fi
    fi
    _make_tmux_plugin_aliases
else
    echo "Could not find tmux. Please install it."
fi
