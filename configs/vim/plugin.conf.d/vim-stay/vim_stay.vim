if !dotfiles#plugin#selected('vim-stay') || exists('g:did_cfg_vim_stay')
    finish
endif
let g:did_cfg_vim_stay = 1

set viewoptions=cursor,folds,slash,unix
