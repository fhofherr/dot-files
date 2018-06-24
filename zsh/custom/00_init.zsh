# -----------------------------------------------------------------------------
# Linuxbrew
# -----------------------------------------------------------------------------
if [ -e "/home/linuxbrew/.linuxbrew" ]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

if [ -e "$HOME/.linuxbrew" ]; then
    export PATH="$HOME/.linuxbrew/bin:$PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# -----------------------------------------------------------------------------
# MacTeX
# -----------------------------------------------------------------------------
# Path helper adds in front of the path. It thus must come first, as it will
# override other things.
if [ -f "/usr/libexec/path_helper" ]; then
    eval `/usr/libexec/path_helper -s`
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
    export PATH="$PATH:$GOPATH/bin"
fi

# -----------------------------------------------------------------------------
# Java
# -----------------------------------------------------------------------------
# See https://github.com/shyiko/jabba
if [ -s "$HOME/.jabba/jabba.sh" ]; then
    source "$HOME/.jabba/jabba.sh"
elif [ -e "/usr/libexec/java_home" ]
then
    export JAVA_HOME="$(/usr/libexec/java_home)"
fi

# -----------------------------------------------------------------------------
# User-local programs
# -----------------------------------------------------------------------------

if [ -e "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# -----------------------------------------------------------------------------
# Local configuration and secrets
# -----------------------------------------------------------------------------
if [ -f "$HOME/.zsh_local" ];then
    source "$HOME/.zsh_local"
fi
