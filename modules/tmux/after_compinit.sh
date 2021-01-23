function __dotfiles_start_tmux() {
    local session_name

    session_name="$1"
    if [[ -z "$session_name" ]]; then
        session_name="default"
    fi

    # Do not autostart tmux if this is not one of our allow listed terminal
    # emulators, we are already in a tmux instance, or this is a neovim
    # terminal.
    if [[ -z "$DOTFILES_TERMINAL_EMULATOR" ]] || [[ -n "$TMUX" ]] || [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
        return 0
    fi

    # Otherwise create a new session
    tmux new-session -A -s "$session_name"
}

__DOTFILES_AUTOSTART_TMUX=1
