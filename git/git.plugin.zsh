#!/usr/bin/env zsh

: ${DOTFILES_DIR:=$HOME/dot-files}
: ${DOTFILES_BIN_DIR:=$DOTFILES_DIR/bin}

: ${DOTFILES_GIT_PRE_COMMIT_ENABLED:=true}
: ${DOTFILES_GIT_PRE_COMMIT_VENV:=$HOME/.local/dotfiles/pre_commit_venv}
: ${DOTFILES_GIT_PRE_COMMIT_BIN:=$DOTFILES_GIT_PRE_COMMIT_VENV/bin}
: ${DOTFILES_GIT_PRE_COMMIT_PIP:=$DOTFILES_GIT_PRE_COMMIT_BIN/pip}

if ! command -v git > /dev/null 2>&1; then
    echo "Git is not installed"
    return 1
fi

function _dotfiles_configure_git {
    "$DOTFILES_BIN_DIR/secure_link_file" "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"

    command git config --global include.path "$DOTFILES_DIR/git/gitconfig.common"
}

function _dotfiles_git_install_pre_commit {
    command mkdir -p "$(dirname $DOTFILES_GIT_PRE_COMMIT_VENV)"
    command python3 -m venv "$DOTFILES_GIT_PRE_COMMIT_VENV"

    "$DOTFILES_GIT_PRE_COMMIT_PIP" install --no-user --upgrade pip
    "$DOTFILES_GIT_PRE_COMMIT_PIP" install --no-user --upgrade -r "$DOTFILES_DIR/git/requirements.txt"
}

if [ ! -e "$HOME/.gitignore_global" ]
then
    printf "Configure git plugin? [y/N]: "
    if read -q; then
        echo
        _dotfiles_configure_git
    fi
fi

if $DOTFILES_GIT_PRE_COMMIT_ENABLED
then
    if [ ! -d "$DOTFILES_GIT_PRE_COMMIT_VENV" ]
    then
        printf "Install pre-commit? [y/N]: "
        if read -q; then
            echo
            _dotfiles_git_install_pre_commit
        fi
    fi
    export PATH="$DOTFILES_GIT_PRE_COMMIT_BIN:$PATH"
fi

export PATH="$DOTFILES_DIR/git/bin:$PATH"
