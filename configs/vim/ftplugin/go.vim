if exists('b:dotfiles_did_go_ftplugin')
  finish
endif
let b:dotfiles_did_go_ftplugin = 1

let g:go_highlight_trailing_whitespace_error = 0

setlocal formatoptions+=r spell spelllang=en_us

if dotfiles#plugin#selected('vim-lsp')
  setlocal foldmethod=expr
        \ foldexpr=lsp#ui#vim#folding#foldexpr()
        \ foldtext=lsp#ui#vim#folding#foldtext()
        \ foldnestmax=3
else
  setlocal foldmethod=indent foldnestmax=3
endif

" vim: sw=2 sts=2 et
