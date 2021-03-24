if !dotfiles#plugin#selected('vim-pandoc-syntax') || exists('g:did_cfg_pandoc_syntax')
    finish
endif
let g:did_cfg_pandoc_syntax = 1

let g:pandoc#syntax#conceal#use = 0

augroup dotfiles_pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
