# See https://direnv.net/
#
# Installation:
#
#   Fedora: dnf install direnv

if command -v direnv > /dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
