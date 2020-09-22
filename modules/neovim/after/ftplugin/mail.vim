if exists('b:dotfiles_did_mail_ftplugin')
  finish
endif
let b:dotfiles_did_mail_ftplugin = 1

setlocal textwidth=72
" Required for format=flowed messages
setlocal formatoptions=awq
