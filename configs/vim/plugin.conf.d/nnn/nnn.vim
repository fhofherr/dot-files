if !dotfiles#plugin#selected('nnn.vim') || exists('g:did_cfg_vim_nnn')
    finish
endif
let g:did_cfg_vim_nnn = 1

let g:nnn#action = {
            \ '<c-t>': 'tab split',
            \ '<c-x>': 'split',
            \ '<c-v>': 'vsplit'
            \ }
