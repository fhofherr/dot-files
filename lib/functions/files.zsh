FILES_TIMESTAMP=$(date "+%Y-%m-%d-%H-%M-%S")
# DEPRECATED: Use secure_link_file instead
function link_file() {
    local src="$1"
    local dest=$2

    [ -z "$src" ] && return 1
    [ -z "$$dest" ] && return 1

    if [ ! -e "$src" ]
    then
        echo "$src does not exist"
        return 1
    fi

    if [ "$src" -ef "$dest" ]
    then
        echo "$src and $dest are the same file."
        return 0
    fi

    if [ -e "$dest" ]
    then
        backup="$dest.$FILES_TIMESTAMP"
        echo "$dest exists. Creating a backup $backup"
        mv $dest $backup
    fi
    ln -s $src $dest
}
