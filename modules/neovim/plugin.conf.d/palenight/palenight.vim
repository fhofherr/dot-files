if !dotfiles#plugin#selected('palenight.vim') || exists('g:did_cfg_palenight')
    finish
endif
let g:did_cfg_palenight = 1

set background=dark
let g:palenight_terminal_italics=1
colorscheme palenight
