if exists('b:dotfiles_did_md_ftplugin')
  finish
endif
let b:dotfiles_did_md_ftplugin = 1

let g:markdown_syntax_conceal = 0
let g:markdown_fenced_languages = [ 'go', 'python' ]

setlocal textwidth=72 spell spelllang=en_us

" vim: sw=2 sts=2 et
