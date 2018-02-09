" ---------------------------------------------------------------------------
"
" Delimitmate
"
" ---------------------------------------------------------------------------

augroup delimitmate
    au FileType * let b:delimitMate_expand_cr = 1
    au FileType * let b:delimitMate_expand_space = 1

    au FileType clojure let b:delimitMate_quotes = "\""
augroup END
