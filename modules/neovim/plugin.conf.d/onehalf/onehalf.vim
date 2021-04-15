if !dotfiles#plugin#selected('onehalf') || exists('g:did_cfg_onehalf')
    finish
endif
let g:did_cfg_onehalf = 1

if $DOTFILES_COLOR_SCHEME == 'onehalf-dark'
    set background=dark
    colorscheme onehalfdark
endif

if $DOTFILES_COLOR_SCHEME == 'onehalf-light'
    set background=light
    colorscheme onehalflight
endif

