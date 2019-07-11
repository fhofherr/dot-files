# -----------------------------------------------------------------------------
# ASDF
# -----------------------------------------------------------------------------
if [ -d "$HOME/.asdf" ]; then
   source "$HOME/.asdf/asdf.sh"
   source "$HOME/.asdf/completions/asdf.bash"
fi

# Check if asdf java plugin is installed and set JAVA_HOME to the current
# version of java.
# The 10_aliases.zsh file contains a wrapper around asdf which changes the
# JAVA_HOME whenever a new package local or global version of java is selected.
if [ -d "$HOME/.asdf/plugins/java" ] && [[ "$(\asdf current java 2>&1)" =~ "^([-_.a-zA-Z0-9]+)[[:space:]]*\(set by.*$" ]]; then
    export JAVA_HOME=$(\asdf where java ${match[1]})
fi

# -----------------------------------------------------------------------------
# FZF
# -----------------------------------------------------------------------------
if [ -f "$HOME/.fzf.zsh" ]; then
   source "$HOME/.fzf.zsh"
fi

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------
if [ -d "/usr/local/go" ]
then
    export PATH="/usr/local/go/bin:$PATH"
fi

if which go > /dev/null; then
    if [ -e "/usr/local/opt/go/libexec/bin" ]; then
        export PATH="/usr/local/opt/go/libexec/bin:$PATH"
    fi
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# -----------------------------------------------------------------------------
# Utilities and user-local programs
# -----------------------------------------------------------------------------
if [ -d "$DOTFILES_DIR/bin" ]; then
    export PATH="$DOTFILES_DIR/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi
# -----------------------------------------------------------------------------
# Local configuration and secrets
# -----------------------------------------------------------------------------
if [ -f "$HOME/.zsh_local" ];then
    source "$HOME/.zsh_local"
fi
