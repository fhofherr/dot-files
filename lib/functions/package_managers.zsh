function brew_install() {
    local pkgs="$1"
    if [ -z "$pkgs" ]
    then
        echo "No packages to install"
        return 1
    fi
    if [[ "$OSTYPE" = darwin* ]]
    then
        echo "Installing $pkgs"
        brew install $pkgs > /dev/null
    fi
}

function apt_install() {
    local pkgs="$1"
    if [ -z "$pkgs" ]
    then
        echo "No packages to install"
        return 1
    fi
    if [[ "$OSTYPE" = linux* ]] && which apt-get > /dev/null
    then
        echo "Installing $pkgs"
        sudo sh -c "apt-get install -y $pkgs > /dev/null"
    fi
}
