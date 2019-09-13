# -----------------------------------------------------------------------------
# ASDF
# -----------------------------------------------------------------------------
function _asdf_set_java_home() {
    if command -v asdf > /dev/null 2>&1
    then
        if [[ "$(\asdf current java 2>&1)" =~ "^([-_.a-zA-Z0-9]+)[[:space:]]*\(set by.*$" ]]; then
            export JAVA_HOME=$(\asdf where java ${match[1]})
        else
            export JAVA_HOME=''
        fi
        if [ $DOTFILES_VERBOSE ]; then
            echo "asdf_java_wrapper: set JAVA_HOME to '$JAVA_HOME'"
        fi

    fi
}
alias asdf-set-java-home="_asdf_set_java_home"
# -----------------------------------------------------------------------------
# Nvim/Vim
# -----------------------------------------------------------------------------
if [ -n "$NVIM_LISTEN_ADDRESS" ]
then
    if [ -n "$NEOVIM_NVR" ]
    then
        alias nvim="$NEOVIM_NVR -p"
        alias nvr="$NEOVIM_NVR"
    else
        echo "Don't nest neovim!"
    fi
fi
alias e="nvim"
alias vim="nvim"
alias view="nvim -R"

# -----------------------------------------------------------------------------
# pbcopy/pbpaste for Linux
# -----------------------------------------------------------------------------

if command -v xclip > /dev/null 2>&1; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi
