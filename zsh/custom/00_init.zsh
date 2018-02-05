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
# FZF
# -----------------------------------------------------------------------------
if [ -f "$HOME/.fzf.zsh" ]; then
   source "$HOME/.fzf.zsh"
fi

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------
if which go > /dev/null; then
    if [ -e "/usr/local/opt/go/libexec/bin" ]; then
        export PATH="/usr/local/opt/go/libexec/bin:$PATH"
    fi
    export GOPATH="$HOME/go"
    export PATH="$PATH:$GOPATH/bin"
fi

# -----------------------------------------------------------------------------
# Pyenv
# -----------------------------------------------------------------------------
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
else
    if which python3 > /dev/null; then
        py3bin="$(python3 -m site --user-base)/bin"
        if [ -d "$py3bin" ]; then
            export PATH="$PATH:$py3bin"
        fi
    fi
    if which python2 > /dev/null; then
        py2bin="$(python2 -m site --user-base)/bin"
        if [ -d "$py2bin" ]; then
            export PATH="$PATH:$py2bin"
        fi
    fi
    if which python > /dev/null; then
        pybin="$(python -m site --user-base)/bin"
        if [ -d "$pybin" ]; then
            export PATH="$PATH:$pybin"
        fi
    fi
fi

if which pyenv-virtualenv-init > /dev/null; then
    eval "$(pyenv virtualenv-init -)"
fi

# -----------------------------------------------------------------------------
# RVM
# -----------------------------------------------------------------------------
if [ -e "$HOME/.rvm/bin" ]; then
    export PATH="$PATH:$HOME/.rvm/bin"
fi

# -----------------------------------------------------------------------------
# MacTeX
# -----------------------------------------------------------------------------
if [ -f "/usr/libexec/path_helper" ]; then
    eval `/usr/libexec/path_helper -s`
fi

# -----------------------------------------------------------------------------
# Secrets
# -----------------------------------------------------------------------------
if [ -f "$HOME/.zsh_secrets" ];then
    source "$HOME/.zsh_secrets"
fi
