" ---------------------------------------------------------------------------
"
" Delimitmate
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('delimitMate') || exists('g:did_cfg_delimitmate')
    finish
endif
let g:did_cfg_delimitmate = 1

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

augroup delimitmate
    au FileType markdown let b:delimitMate_expand_cr = 0
    au FileType markdown let b:delimitMate_expand_space = 0

    au FileType clojure let b:delimitMate_quotes = "\""
augroup END
