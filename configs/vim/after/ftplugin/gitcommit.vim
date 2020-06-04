if exists('b:dotfiles_did_gitcommit_ftplugin')
  finish
endif
let b:dotfiles_did_gitcommit_ftplugin = 1

setlocal spell spelllang=en_us
call setpos('.', [0, 1, 1, 0])

" vim: sw=2 sts=2 et
