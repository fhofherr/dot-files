if exists('b:dotfiles_did_md_ftplugin')
  finish
endif
let b:dotfiles_did_md_ftplugin = 1

let g:markdown_syntax_conceal = 0
let g:markdown_fenced_languages = [ 'go', 'python' ]

augroup dotfiles_markdown
  autocmd!
  autocmd BufEnter *.md,*mkd,*.markdown setlocal textwidth=72
augroup END

" vim: sw=2 sts=2 et
