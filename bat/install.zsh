#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi
source "$DOTFILES_DIR/lib/functions.zsh"

if $DOTFILES_MINIMAL
then
    echo "Minimal installation. Skipping ASDF"
    exit 0
fi

if command -v bat > /dev/null 2>&1
then
    BAT_CONFIG_DIR=$(bat --config-dir)
    BAT_THEME_DIR="$BAT_CONFIG_DIR/themes"
    mkdir -p $BAT_THEME_DIR
    git_clone_or_pull https://github.com/dracula/sublime.git $BAT_THEME_DIR/dracula

    link_file "$DOTFILES_DIR/bat/config" $(bat --config-file)
    bat cache --build
fi
