if !dotfiles#plugin#selected('gruvbox') || exists('g:did_cfg_gruvbox')
    finish
endif
let g:did_cfg_gruvbox = 1

set background=dark
if $DOTFILES_COLOR_SCHEME == 'gruvbox-light'
    set background=light
endif
colorscheme gruvbox
