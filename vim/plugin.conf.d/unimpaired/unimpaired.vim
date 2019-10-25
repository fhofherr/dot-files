" ---------------------------------------------------------------------------
"
" Unimpaired
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('vim-unimpaired') || exists('g:did_cfg_unimpaired')
    finish
endif
let g:did_cfg_unimpaired = 1

 let g:nremap = {"[": "-", "]": "_"}
 let g:xremap = {"[": "-", "]": "_"}
 let g:oremap = {"[": "-", "]": "_"}
