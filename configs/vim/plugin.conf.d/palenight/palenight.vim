if !dotfiles#plugin#selected('palenight.vim') || exists('g:did_cfg_palenight')
    finish
endif
let g:did_cfg_palenight = 1

set background=dark
set termguicolors
let g:palenight_terminal_italics=1
colorscheme palenight
