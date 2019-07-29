# -----------------------------------------------------------------------------
# ASDF
# -----------------------------------------------------------------------------
function _asdf_set_java_home() {
    if command -v asdf > /dev/null 2>&1
    then
        if [[ "$(\asdf current java 2>&1)" =~ "^([-_.a-zA-Z0-9]+)[[:space:]]*\(set by.*$" ]]; then
            export JAVA_HOME=$(\asdf where java ${match[1]})
        else
            export JAVA_HOME=''
        fi
        if [ $DOTFILES_VERBOSE ]; then
            echo "asdf_java_wrapper: set JAVA_HOME to '$JAVA_HOME'"
        fi

    fi
}
alias asdf-set-java-home="_asdf_set_java_home"
# -----------------------------------------------------------------------------
# Nvim/Vim
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# SSH
# -----------------------------------------------------------------------------
alias ssh='TERM=xterm-color ssh'

# -----------------------------------------------------------------------------
# Tmux
# -----------------------------------------------------------------------------
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

alias tmux="TERM=tmux-256color tmux"
alias tls="tmux ls"
alias tns="_tmux_new_session"
alias tks="tmux kill-session -t"
alias tnsp="_tmux_new_project_session"
alias tnsd="tmux new-session -d -s"
alias tnw="tmux new-window"
alias tss="tmux switch-client -t"
alias tas="tmux attach -t"
