# vim: set ft=zsh:

: ${DOTFILES_DIR:=$HOME/dot-files}

DOTFILES_GOLANG_PLUGIN_E_NOT_FOUND=254

function _go_mod_get {
    if [ $#@ = 0 ]; then
        echo "Usage: _go_get [flags] <repo>"
        return 1
    fi
    local curdir=$PWD
    cd /tmp
    echo -n "Getting ${@[-1]}: "
    if $(GO111MODULE=on command go get $@ > /dev/null 2>&1); then
        echo "OK"
    else
        echo "Failed"
    fi
    cd $curdir
}

function _go_add_shim {
    local binname="$1"
    if [ -z "$binname" ]; then
        echo "Usage: _go_add_shim <binary name>"
        return 1
    fi
    mkdir -p "$DOTFILES_DIR/golang/shims"
    local shimfile="$DOTFILES_DIR/golang/shims/$binname"
    if [ -f "$shimfile" ]; then
        return 0
    fi
    cat  > $shimfile <<EOF
#!/usr/bin/env bash

GO=\$(command -v go)
ASDF=\$(command -v asdf)

if [ -n "\$ASDF" ]
then
    ASDF_GO=\$(\$ASDF which go 2> /dev/null)
    if [ -n "\$ASDF_GO" ]
    then
        GO="\$ASDF_GO"
    fi
fi

if [ -z "\$GO" ]
then
    echo "Could not find go"
    exit 1
fi

GOPATH="\$(go env GOPATH)"

if [ ! -x "\$GOPATH/bin/$binname" ]
then
    echo "$binname not found"
    exit 1
fi

exec "\$GOPATH/bin/$binname" "\$@"
EOF
    chmod +x $shimfile
}

function _go_update_binaries {
    _go_mod_get "github.com/go-delve/delve/cmd/dlv@latest" && _go_add_shim "dlv"
    _go_mod_get "github.com/golangci/golangci-lint/cmd/golangci-lint@latest" && _go_add_shim "golangci-lint"
    _go_mod_get "github.com/psampaz/go-mod-outdated@latest" && _go_add_shim "go-mod-outdated"
    _go_mod_get "golang.org/x/lint/golint@latest" && _go_add_shim "golint"
    _go_mod_get "golang.org/x/tools/cmd/goimports@latest" && _go_add_shim "goimports"
    _go_mod_get "golang.org/x/tools/gopls@latest" && _go_add_shim "gopls"
    _go_mod_get "golang.org/x/tools/cmd/godoc@latest" && _go_add_shim "godoc"
    _go_mod_get "github.com/fatih/gomodifytags" && _go_add_shim "gomodifytags"

    if command -v protoc > /dev/null 2>&1; then
        _go_mod_get "github.com/golang/protobuf/protoc-gen-go@latest" && _go_add_shim "protoc-gen-go"
    fi
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

export PATH="$DOTFILES_DIR/golang/shims:$PATH"
