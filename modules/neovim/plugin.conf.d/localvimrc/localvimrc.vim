if !dotfiles#plugin#selected('vim-localvimrc') || exists('g:did_cfg_localvimrc')
    finish
endif
let g:did_cfg_localvimrc = 1

let g:localvimrc_persistent=1
