" ---------------------------------------------------------------------------
"
" Supertabs
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('supertab') || exists('g:did_cfg_supertab')
    finish
endif
let g:did_cfg_supertab = 1


let g:SuperTabDefaultCompletionType = "<c-n>"
