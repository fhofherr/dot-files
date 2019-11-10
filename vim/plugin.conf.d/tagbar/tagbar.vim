if !dotfiles#plugin#selected('tagbar') || exists('g:did_cfg_tagbar')
    finish
endif
let g:did_cfg_tagbar = 1

let g:tagbar_autoclose = 1
