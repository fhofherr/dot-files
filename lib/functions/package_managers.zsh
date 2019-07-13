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

function brew_cask_install() {
    local pkgs="$1"
    if [ -z "$pkgs" ]
    then
        echo "No packages to install"
        return 1
    fi
    if [[ "$OSTYPE" = darwin* ]]
    then
        echo "Installing $pkgs"
        brew cask install $pkgs > /dev/null
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

function asdf_install_global() {
    local plugin_name="$1"
    local version="$2"

    [ -z "$plugin_name" ] && return 1
    [ -z "$version" ] && return 1

    if ! command -v asdf > /dev/null 2>&1
    then
        echo "command asdf not found"
        return 1
    fi

    asdf plugin-add $plugin_name
    asdf install $plugin_name $version
    asdf global $plugin_name $version
}
