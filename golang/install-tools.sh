#!/bin/bash

: "${GOBIN:=$HOME/go/bin}"
: "${LOG_FILE:=/tmp/dotfiles/golang/install-tools.log}"

GO_TOOLS=(
    "github.com/bufbuild/buf/cmd/buf@latest"
    "github.com/bufbuild/buf/cmd/protoc-gen-buf-check-breaking@latest"
    "github.com/bufbuild/buf/cmd/protoc-gen-buf-check-lint@latest"
    "github.com/DarthSim/overmind@master"
    "github.com/fatih/gomodifytags@latest"
    "github.com/go-delve/delve/cmd/dlv@latest"
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
    "github.com/golang/protobuf/protoc-gen-go@latest"
    "github.com/psampaz/go-mod-outdated@latest"
    "golang.org/x/lint/golint@latest"
    "golang.org/x/tools/cmd/godoc@latest"
    "golang.org/x/tools/cmd/goimports@latest"
    "golang.org/x/tools/cmd/stringer@latest"
    "golang.org/x/tools/gopls@latest"
)

mkdir -p "$(dirname $LOG_FILE)"
rm -f "$LOG_FILE"

function _go_mod_get {
    if [ $# -eq 0 ]; then
        echo "Usage: _go_mod_get [flags] <repo>"
        return 1
    fi
    local curdir="$PWD"
    cd /tmp || return 1
    echo -n "Getting " "${@: -1}" ":"
    if GO111MODULE=on command go get "$@" > "$LOG_FILE" 2>&1; then
        echo "OK"
    else
        echo "Failed"
    fi
    cd "$curdir" || return 1
}

for tool in ${GO_TOOLS[*]}; do
    _go_mod_get "$tool"
done
