if !dotfiles#plugin#selected('vim-gutentags') || exists('g:did_cfg_vim_gutentags')
    finish
endif
let g:did_cfg_vim_gutentags = 1

let g:gutentags_modules = ['ctags']
let g:gutentags_define_advanced_commands = 1
