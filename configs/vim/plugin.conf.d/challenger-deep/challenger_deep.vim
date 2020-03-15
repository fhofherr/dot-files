if !dotfiles#plugin#selected('challenger-deep') || exists('g:did_cfg_challenger_deep')
    finish
endif
let g:did_cfg_challenger_deep = 1

colorscheme challenger_deep
