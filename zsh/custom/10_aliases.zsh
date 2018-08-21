# -----------------------------------------------------------------------------
# Nvim/Vim
# -----------------------------------------------------------------------------
if [ -n "$NVIM_LISTEN_ADDRESS" ]
then
    if [ -n "$NEOVIM_NVR" ]
    then
        alias nvim="$NEOVIM_NVR"
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
alias tmux="TERM=tmux-256color tmux"
alias tls="tmux ls"
alias tns="tmux new-session -s"
alias tnsd="tmux new-session -d -s"
alias tnw="tmux new-window"
alias tss="tmux switch-client -t"
alias tas="tmux attach -t"

alias wiki="tns wiki nvim -c :VimwikiIndex"
# -----------------------------------------------------------------------------
# todo.txt
# -----------------------------------------------------------------------------
alias todo="todo.sh"
