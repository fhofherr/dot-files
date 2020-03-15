function _dotfiles_load_vim_config {
    local nvr

    nvr = "$(command -v nvr 2>/dev/null)"

    if [ -n "$NVIM_LISTEN_ADDRESS" ] && [ -n "$nvr" ]; then
        export EDITOR="$nvr"
        alias nvim="$nvr"
        alias view="$nvr -R"
    fi
}
