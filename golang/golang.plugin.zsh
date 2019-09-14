# vim: set ft=zsh:

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
    $(go env GOPATH)/bin/godoc -http localhost:"$port"
}
