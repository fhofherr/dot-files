if exists('g:dotfiles_did_go_ftplugin')
  finish
endif
let g:dotfiles_did_go_ftplugin = 1

let g:go_highlight_trailing_whitespace_error = 0

augroup dotfiles_go
  autocmd!
  autocmd BufEnter *.go setlocal
        \ formatoptions+=r
        " \ foldmethod=indent
        \ spell spelllang=en_us
augroup END

" vim: sw=2 sts=2 et
