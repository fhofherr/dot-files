function rvm() {
    if [ ! -f "$HOME/.rvm/scripts/rvm" ]
    then
        echo "RVM is not installed"
        return
    fi
    unhash -f rvm
    source "$HOME/.rvm/scripts/rvm"
    local rvm_cmd=$(command -v rvm)
    if [[ ! -z "$@" ]]
    then
        $rvm_cmd $@
    fi
}
