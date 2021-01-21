function _nnn() {
    if [[ -z "$NNN_COMMAND" ]]; then
        echo "nnn not installed"
        return 0
    fi

    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behavior is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    local NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    "$NNN_COMMAND" -eER "$@"
    if [ -f "$NNN_TMPFILE" ]; then
        source "$NNN_TMPFILE"
        /usr/bin/rm -f "$NNN_TMPFILE" > /dev/null 2>&1
    fi
}
