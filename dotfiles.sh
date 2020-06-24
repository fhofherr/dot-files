#!/bin/bash
: "${POETRY_URL:=https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py}"

CURL="$(command -v curl)"
POETRY="$(command -v poetry)"
PYTHON3="$(command -v python3)"

if [ -z "$PYTHON3" ]; then
    echo "python3 is not installed"
    exit 1
fi

if [ -z "$POETRY" ]; then
    POETRY="$HOME/.poetry/bin/poetry"

    if [ ! -e "$POETRY" ]; then
        echo "Installing poetry"
        if [ -z "$CURL" ]; then
            echo "curl is not installed"
            exit 1
        fi

        "$CURL" -sSL "$POETRY_URL" | "$PYTHON3"
        # Fix python interpreter of poetry
        sed -i.bak "s;#!/usr/bin/env python;#!/usr/bin/env python3;" "$POETRY"
        rm "${POETRY}.bak"
    fi

    if [ "$($POETRY config virtualenvs.in-project)" != "true" ]; then
        "$POETRY" config virtualenvs.in-project true
    fi
fi

if ! "$POETRY" install; then
    echo "$POETRY install failed"
    exit 1
fi

"$POETRY" run dotfiles "${@}"
