# vim: set ft=zsh:

if [ -f "$ZSH/plugins/golang/golang.plugin.zsh" ]; then
    source "$ZSH/plugins/golang/golang.plugin.zsh"
fi

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
