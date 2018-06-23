if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi
source "$DOTFILES_DIR/lib/functions/files.zsh"
source "$DOTFILES_DIR/lib/functions/git.zsh"
source "$DOTFILES_DIR/lib/functions/package_managers.zsh"
