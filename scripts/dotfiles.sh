#!/bin/bash
: "${POETRY_URL:=https://install.python-poetry.org}"

ASDF="$(command -v asdf 2>/dev/null)"
CURL="$(command -v curl 2>/dev/null)"
POETRY="$(command -v poetry 2>/dev/null)"
PYTHON3="$(command -v python3 2>/dev/null)"

set -eou pipefail

function install_asdf() {
    local latest_tag

    if [[ -n "$ASDF" ]]; then
        return 0
    fi

    if [[ ! -d "$HOME/.asdf" ]]; then
        git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf"
    fi

    pushd "$HOME/.asdf"
    latest_tag="$(git describe --tags --abbrev=0)"
    git checkout "$latest_tag"
    popd
}

function install_poetry() {
    if [[ -z "$POETRY" ]]; then
        echo "Installing poetry"

        if [ -z "$ASDF" ]; then
            echo "asdf is not installed"
            exit 1
        fi
        "$ASDF" plugin add poetry || true
        "$ASDF" install poetry latest
        "$ASDF" global poetry latest
        "$ASDF" reshim poetry
        POETRY="$HOME/.asdf/shims/poetry"
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
    install_asdf
    install_poetry
fi

if [[ ! -e "$(dirname "${BASH_SOURCE[0]}")/.venv" ]]; then
    "$POETRY" install
fi

"$POETRY" run dotfiles "${@}"
