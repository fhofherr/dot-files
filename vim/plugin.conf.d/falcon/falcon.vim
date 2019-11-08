if !dotfiles#plugin#selected('falcon') || exists('g:did_cfg_falcon')
    finish
endif
let g:did_cfg_falcon = 1

colorscheme falcon
