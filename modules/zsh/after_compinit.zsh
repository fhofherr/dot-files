###
### automatically set window title
###
### See: https://wiki.archlinux.org/index.php/zsh#xterm_title

## Should already be loaded
# autoload -Uz add-zsh-hook

function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

###
### open on linux
###

if command -v xdg-open > /dev/null 2>&1; then
    alias open='xdg-open'
fi

###
### colors
###

function dotfiles_set_shell_colors {
    if [[ "$DOTFILES_COLOR_THEME" != 'base16-'* ]]; then
        return 0
    fi

    local fn_name
    fn_name="${DOTFILES_COLOR_THEME//base16-/base16_}"
    eval "$fn_name"
}
