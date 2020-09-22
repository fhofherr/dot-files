function _dotfiles_configure_nvr {
    local nvr_cmd

    nvr_cmd="$(command -v nvr 2>/dev/null)"

    if [[ -z "$nvr_cmd" ]] || [[ -z "$NVIM_LISTEN_ADDRESS" ]]; then
        return 0
    fi

    export EDITOR="$nvr_cmd"
    export VISUAL="$nvr_cmd"

    # Replace aliases for nvim inside the neovim terminal.
    #
    # We want the variable to be replaced during function execution time.
    # shellcheck disable=SC2139
    alias nvim="$nvr_cmd"
    # shellcheck disable=SC2139
    alias view="$nvr_cmd -R"
}

_dotfiles_configure_nvr
