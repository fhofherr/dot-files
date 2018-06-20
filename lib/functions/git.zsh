function git_clone_or_pull() {
    local url=$1
    local dest=$2

    [ -z "$url" ] && return 1
    [ -z "$$dest" ] && return 1

    if [ ! -e "$dest" ];
    then
        git clone $url $dest > /dev/null
    elif [ -d "$dest" ]
    then
        local curdir=$PWD
        cd $dest
        git pull > /dev/null
        cd $curdir
    else
        echo "$dest exists but is not a directory"
        return 1
    fi
}
