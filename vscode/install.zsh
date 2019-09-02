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
    echo "Minimal installation. Skipping Clojure"
    exit 0
fi

brew_cask_install visual-studio-code
if [[ "$OSTYPE" = darwin* ]]
then
    VSCODE_HOME="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" = linux* ]]
then
    VSCODE_HOME="$HOME/.config/Code/User"
    mkdir -p $VSCODE_HOME
    ln -s $HOME/.config/Code $HOME/.config/Code\ -\ OSS
fi

# Link settings. Inspired by
# https://pawelgrzybek.com/sync-vscode-settings-and-snippets-via-dotfiles-on-github/
mkdir -p $VSCODE_HOME
link_file "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_HOME/settings.json"
link_file "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_HOME/keybindings.json"
link_file "$DOTFILES_DIR/vscode/snippets" "$VSCODE_HOME/snippets"

# Install extensions. To update extensions.txt run
#
#     code --list-extensions > $DOTFILES_DIR/vscode/extensions.txt
cat "$DOTFILES_DIR/vscode/extensions.txt" | xargs -L 1 code --force --install-extension
