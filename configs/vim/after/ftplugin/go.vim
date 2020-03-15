if exists('b:dotfiles_did_go_ftplugin')
  finish
endif
let b:dotfiles_did_go_ftplugin = 1

augroup dotfiles_go
  autocmd!
  autocmd BufEnter *.go setlocal formatoptions+=r
augroup END

" vim: sw=2 sts=2 et
