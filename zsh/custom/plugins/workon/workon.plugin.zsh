# The workon plugin allows to quickly switch into a project's root directory
# and start working on it.


# Directories containing projects. If this variable is not set
# search in the projects listed below.
if [ -z "$WORKON_PROJECT_DIRECTORIES" ]; then
    WORKON_PROJECT_DIRECTORIES=(
        "$HOME/Projects"
        "$GOPATH/src/github.com/fhofherr"
    )
fi

function _list_projects {
    local prj_dir=''
    local found_projects=()

    for prj_dir in $WORKON_PROJECT_DIRECTORIES; do
        if [ ! -d "$prj_dir" ]; then
            continue
        fi
        for x in $(ls $prj_dir); do
            if [ -d "$prj_dir/$x/.git" ]; then
                found_projects+="$x"
            fi
        done
    done
    echo $found_projects | tr ' ' '\n' | sort -u
    return 0
}

function _go_to_project {
    local prj_dir=''
    local prj_name=$1

    if [ -z "$prj_name" ]; then
        echo "No project name given"
        return 1
    fi

    for prj_dir in $WORKON_PROJECT_DIRECTORIES; do
        if [ ! -d "$prj_dir" ]; then
            continue
        fi
        for x in $(ls $prj_dir); do
            if [ -d "$prj_dir/$x/.git" ] && [ "$x" = "$prj_name" ]; then
                cd "$prj_dir/$x"
                return 0
            fi
        done
        echo "No such project: $prj_name"
        return 1
    done
}

function _switch_project {
    local prj_name=$1
    if [ -z "$prj_name" ]; then
        echo "No project name given"
        return 1
    fi
    _go_to_project $prj_name
    # TODO project initialization
}

function workon {
    local arg=$1
    if [ -z "$arg" ]; then
        echo "Usage: $0 <list|<project-name>>"
        return 1
    fi
    if [ "$arg" = "list" ] || [ "$arg" = "list-projects" ]; then
        _list_projects
    else
        _go_to_project $arg
    fi
}
