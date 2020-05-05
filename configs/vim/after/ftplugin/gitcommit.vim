if exists('g:dotfiles_did_gitcommit_ftplugin')
  finish
endif
let g:dotfiles_did_gitcommit_ftplugin = 1

augroup dotfiles_gitcommit
  autocmd!
  autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
augroup END

" vim: sw=2 sts=2 et
