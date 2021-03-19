if !dotfiles#plugin#selected('papercolor-theme') || exists('g:did_cfg_papercolor')
    finish
endif
let g:did_cfg_papercolor = 1

set background=dark
if $DOTFILES_COLOR_SCHEME == 'papercolor-light'
    set background=light
endif
colorscheme PaperColor
