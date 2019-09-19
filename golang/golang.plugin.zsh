# vim: set ft=zsh:

DOTFILES_GOLANG_PLUGIN_E_NOT_FOUND=254

function _go_shim {
    local binname=$1
    shift
    local binpath="$(go env GOPATH)/bin/$binname"
    if [ ! -e  $binpath ]; then
        echo "not found: $binpath"
        return $DOTFILES_GOLANG_PLUGIN_E_NOT_FOUND
    fi
    $binpath $@
}

function go-cov-pkg {
    local pkg=$1
    local coverage_file=$2

    if [ -z "$coverage_file" ]; then
        coverage_file=".coverage.out"
    fi
    if [ -z "$pkg" ]; then
        pkg="./..."
    fi

    if ! [[ "$pkg" == ./* ]]; then
        pkg="./$pkg"
    fi

    if go test -covermode=atomic -coverprofile $coverage_file $pkg; then
        go tool cover -html=$coverage_file
    fi
}

function godoc-serve {
    local port="$1"
    if [ -z "$port" ]; then
        port="6060"
    fi
    local godoc="$(go env GOPATH)/bin/godoc"
    if [ ! -f "$godoc" ]; then
        echo "godoc is not installed"
        return 1
    fi
    _go_shim godoc -http localhost:"$port"
}

export PATH="$DOTFILES_DIR/golang/shims:$PATH"
