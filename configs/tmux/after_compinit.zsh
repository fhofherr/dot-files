function _tmux_new_session {
    if [ -z "$1" ]
    then
        local session_name="default"
    else
        local session_name="$1"
    fi
    if [ -z "$TMUX" ]
    then
        tmux new-session -s $session_name
    else
        tmux new-session -s $session_name -d
        tmux switch-client -t $session_name
    fi
}

function _tmux_new_project_session {
    local session_name curdir session_dir

    curdir="$PWD"
    if [ -n "$1" ]; then
        session_dir="$1"
    else
        session_dir="$PWD"
    fi
    session_name="$(basename $session_dir)"

    if [ ! -e "$session_dir" ]; then
        echo "does not exist: $session_dir"
        return 1
    fi
    if [ ! -d "$session_dir" ]; then
        echo "not a directory: $session_dir"
        return 1
    fi

    cd "$session_dir"
    tmux new-session -s "$session_name" -d
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name" > /dev/null 2>&1
    else
        tmux attach -t "$session_name"
    fi
    cd "$curdir"
}
