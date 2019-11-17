if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
    source "$DOTFILES_DIR/lib/functions.zsh"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    return 1
fi

# Ensure XDG_CONFIG_HOME is set
: ${XDG_CONFIG_HOME:=$HOME/.config}

# Ensure XDG_DATA_HOME is set
: ${XDG_DATA_HOME:=$HOME/.local/share}

# Set a default color theme and profile. The profile is only relevant if
# the theme supports it.
: ${DOTFILES_COLOR_THEME:=onehalf}
: ${DOTFILES_COLOR_PROFILE:=light}

export DOTFILES_COLOR_THEME
export DOTFILES_COLOR_PROFILE

DOTFILES_KITTY_CMD="$(command -v kitty 2> /dev/null)"
DOTFILES_KITTY_CFG_DIR="$XDG_CONFIG_HOME/kitty"
DOTFILES_KITTY_DATA_DIR="$XDG_DATA_HOME/kitty"

function _kitty_link_config {
    link_file "$DOTFILES_DIR/kitty/config" "$DOTFILES_KITTY_CFG_DIR"
}

function _kitty_install_theme {
    local color_theme_file="$DOTFILES_KITTY_DATA_DIR/color_scheme.conf"
    local themes_dir="$DOTFILES_KITTY_DATA_DIR/themes"

    rm -f "$color_theme_file"
    mkdir -p "themes_dir"
    case "$DOTFILES_COLOR_THEME" in
        "challenger-deep")
            git_clone_or_pull "https://github.com/challenger-deep-theme/kitty" "$themes_dir/challenger-deep"
            link_file "$themes_dir/challenger-deep/challenger-deep.conf" "$color_theme_file"
            ;;
        "dracula")
            git_clone_or_pull "https://github.com/dexpota/kitty-themes" "$themes_dir/kitty-themes"
            link_file "$themes_dir/kitty-themes/Dracula.conf" "$color_theme_file"
            ;;
        "falcon")
            git_clone_or_pull "https://github.com/fenetikm/falcon" "$themes_dir/falcon"
            link_file "$themes_dir/falcon/kitty/kitty.falcon.conf" "$color_theme_file"
            ;;
        "onehalf")
            git_clone_or_pull "https://github.com/sonph/onehalf" "$themes_dir/onehalf"
            if [ "$DOTFILES_COLOR_PROFILE" = "light" ]; then
                link_file "$themes_dir/onehalf/kitty/onehalf-light.conf" "$color_theme_file"
            else
                link_file "$themes_dir/onehalf/kitty/onehalf-dark.conf" "$color_theme_file"
            fi
            ;;
        *)
            if [ -n "$DOTFILES_COLOR_THEME" ]; then
                echo "Unknown color theme: $DOTFILES_COLOR_THEME"
            fi
            # Don't install a color theme
            echo -n "" > "$color_theme_file"
            ;;
    esac
}

function _kitty_install_dependencies {
    mkdir -p "$DOTFILES_KITTY_DATA_DIR"
    _kitty_install_theme
    _kitty_link_config
}

function _kitty_load_completion {
    local completion_file="$DOTFILES_KITTY_DATA_DIR/completion.zsh"
    if [ ! -f "$completion_file" ]; then
        $DOTFILES_KITTY_CMD + complete setup zsh > "$completion_file"
    fi
    source "$completion_file"
}

if [ -z "$DOTFILES_KITTY_CMD" ]; then
    echo "Kitty does not seem to be installed"
    return 1
fi

if [ ! -d "$DOTFILES_KITTY_CFG_DIR" ]; then
    printf "Install kitty plugin dependencies? [y/N]: "
    if read -q; then
        echo
        _kitty_install_dependencies
    fi
fi

_kitty_load_completion
