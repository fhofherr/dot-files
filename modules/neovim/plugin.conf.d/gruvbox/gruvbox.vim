if !dotfiles#plugin#selected('gruvbox') || exists('g:did_cfg_gruvbox')
    finish
endif
let g:did_cfg_gruvbox = 1

set background=dark
colorscheme gruvbox
