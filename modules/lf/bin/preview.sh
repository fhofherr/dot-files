#!/bin/bash

function preview_bat() {
    if command -v bat >/dev/null 2>&1; then
        command bat --color always "$@"
    else
        command cat "$@"
    fi
}

case "$1" in
*) preview_bat "$@" ;;
esac
