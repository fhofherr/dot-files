# vim: set ft=zsh:

: ${DOTFILES_DIR:=$HOME/dot-files}
: ${GOBIN:=$HOME/go/bin}

# Some distros disable GOPROXY, which leads to awkward bugs.
# See
#  * https://github.com/golang/go/issues/37140#issuecomment-583776533
#  * https://github.com/golang/go/issues/34092
: ${GOPROXY:=https://proxy.golang.org,direct}


DOTFILES_GOLANG_PLUGIN_E_NOT_FOUND=254

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
    local docker=$(command -v podman 2> /dev/null)
    if [ -z "$docker" ]; then
        docker=$(command -v docker 2> /dev/null)
    fi
    if [ -z "$docker" ]; then
        "$DOTFILES_DIR/golang/shims/godoc" -http "127.0.0.1:$port"
        return 0
    fi
    local volflag modpath
    if [ -e "$PWD/go.mod" ]; then
        local module=$(basename $PWD)
        volflag="--volume $PWD:/tmp/go/src/$module"
        modpath="pkg/$module"
    fi
    eval "$docker run --rm --env GOPATH=/tmp/go $volflag --publish 127.0.0.1:$port:$port golang bash -c 'go get golang.org/x/tools/cmd/godoc && echo http://localhost:$port/$modpath && /tmp/go/bin/godoc -http=:$port'"
}

function go-outdated {
    local go_mod_outdated go

    go="$(command -v go 2> /dev/null)"
    if [ -z "$go" ]; then
        echo "go not installed"
    fi

    go_mod_outdated="$(command -v go-mod-outdated 2> /dev/null)"
    if [ -z "$go_mod_outdated" ]; then
        echo "go-mod-outdated not installed"
    fi

    if [ "$1" = "help" ]; then
        "$go_mod_outdated" -help
        return 0
    fi

    "$go" list -u -m -json all | "$go_mod_outdated" "$@"
}

export GOPROXY
if [ -d "$GOBIN" ]; then
    export GOBIN
    export PATH="$GOBIN:$PATH"
fi
