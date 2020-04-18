function _dotfiles_configure_nvr {
    local nvr_cmd
    nvr_cmd="$(command -v nvr 2>/dev/null)"

    if [ -z "$nvr_cmd" ]; then
        return 0
    fi

    # Replace aliases for nvim inside the neovim terminal
    if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        alias nvim="$nvr_cmd"
        alias e="$nvr_cmd"
        alias et="$nvr_cmd -p"
        alias es="$nvr_cmd -o"
        alias ev="$nvr_cmd -O"
        alias view="$nvr_cmd -R"
    fi
}

_dotfiles_configure_nvr
