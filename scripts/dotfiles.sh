#!/bin/bash
: "${POETRY_URL:=https://install.python-poetry.org}"

CURL="$(command -v curl)"
POETRY="$(command -v poetry)"
PYTHON3="$(command -v python3)"

set -eou pipefail

function install_poetry() {
    POETRY="$HOME/.local/bin/poetry"

    if [[ ! -e "$POETRY" ]]; then
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

    if [[ "$($POETRY config virtualenvs.in-project)" != "true" ]]; then
        "$POETRY" config virtualenvs.in-project true
    fi
}

function install_raspberrypi_dependencies() {
    sudo apt install \
        autoconf \
        automake \
        bear \
        build-essential \
        cargo \
        cmake \
        curl \
        fonts-noto-color-emoji \
        g++ \
        gettext \
        libffi-dev \
        libssl-dev \
        libtool \
        libtool-bin \
        ninja-build \
        pkg-config \
        python3-dev \
        universal-ctags \
        unzip \
        zsh
}

function install_dependencies() {
    case $(hostname) in
        pi400*)
            install_raspberrypi_dependencies
            ;;
        # TODO install dependencies for other hosts here.
    esac
}

if [[ -z "$PYTHON3" ]]; then
    echo "python3 is not installed"
    exit 1
fi

if [[ -z "$POETRY" ]]; then
    install_dependencies
    install_poetry
fi

if [[ ! -e "$(dirname "${BASH_SOURCE[0]}")/.venv" ]]; then
    "$POETRY" install
fi

"$POETRY" run dotfiles "${@}"
