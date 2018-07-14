local pyenv_cmd=$(command -v pyenv)

function pyenv() {
    if [ -z "$pyenv_cmd" ]
    then
        echo "Pyenv is not installed"
        return
    fi
    unhash -f pyenv
    eval "$($pyenv_cmd init -)"
    eval "$($pyenv_cmd virtualenv-init -)"
    $pyenv_cmd $@
}
