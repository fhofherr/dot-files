# See https://direnv.net/
#
# Installation:
#
#   Fedora: dnf install direnv
#
# TODO figure out if the asdf-direnv plugin is interesting: https://github.com/asdf-community/asdf-direnv

: ${XDG_CONFIG_HOME:=$HOME/.config}

DOTFILES_DIRENV_CONFIG_FILE="$XDG_CONFIG_HOME/direnv/direnvrc"

function _link_direnv_config {
    if [ -f "$HOME/.zsh_dotfiles_init" ]
    then
        source "$HOME/.zsh_dotfiles_init"
        source "$DOTFILES_DIR/lib/functions.zsh"
    else
        echo "Could not find '$HOME/.zsh_dotfiles_init'!"
        echo "Execute over-all install script!"
        return 1
    fi
    mkdir -p "$(dirname $DOTFILES_DIRENV_CONFIG_FILE)"
    link_file "$DOTFILES_DIR/direnv/direnvrc" "$DOTFILES_DIRENV_CONFIG_FILE"
}

if command -v direnv > /dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
