if !dotfiles#plugin#selected('echodoc.vim') || exists('g:did_cfg_echodoc_vim')
    finish
endif
let g:did_cfg_echodoc_vim = 1

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'echo'
