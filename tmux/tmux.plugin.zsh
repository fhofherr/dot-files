#!/usr/bin/env zsh

# Automatically start tmux
: ${ZSH_TMUX_AUTOSTART:=false}
# Terminal emulators for which we want to start tmux
: ${ZSH_TMUX_ALLOWED_TERMINAL_EMULATORS:=alacritty konsole}
# Name of our default session
: ${ZSH_TMUX_DEFAULT_SESSION:="default"}

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
    local session_name curdir sessiondir

    curdir=$PWD
    if [ -n "$1" ]; then
        sessiondir=$1
        session_name=$(basename $1)
    else
        sessiondir=$PWD
        session_name=$(basename $PWD)
    fi

    if [ ! -e "$sessiondir" ]; then
        echo "does not exist: $sessiondir"
        return 1
    fi
    if [ ! -d "$sessiondir" ]; then
        echo "not a directory: $sessiondir"
        return 1
    fi

    cd $sessiondir
    TERM=tmux-256color tmux new-session -s $session_name -d
    TERM=tmux-256color tmux switch-client -t $session_name > /dev/null 2>&1
    cd $curdir
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

function _tmux_plugin_autostart_tmux {
    if [[ "$ZSH_TMUX_AUTOSTART" != "true" ]]; then
        echo "ZSH_TMUX_AUTOSTART was false"
        return 0
    fi
    if [[ $TERM =~ tmux ]] || [ -n "$TMUX" ]; then
        return 0
    fi
    # This requires the detterm utility.
    # See https://github.com/fhofherr/detterm
    if ! command -v detterm > /dev/null 2>&1; then
        echo "Could not find detterm utility"
        return 0
    fi
    local terminal_emulator=$(DETTERM_EMULATORS="$ZSH_TMUX_ALLOWED_TERMINAL_EMULATORS" detterm)
    if [ -z "$terminal_emulator" ]; then
        return 0
    fi
    export TERM="tmux-256color"
    # Create a new session if it does not exists or attach
    # to the existing one
    exec tmux new-session -A -s $ZSH_TMUX_DEFAULT_SESSION
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
    _tmux_plugin_autostart_tmux
else
    echo "Could not find tmux. Please install it."
fi
