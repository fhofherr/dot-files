" ---------------------------------------------------------------------------
"
" UltiSnips
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('ultisnips') || exists('g:did_cfg_ultisnips')
    finish
endif
let g:did_cfg_ultisnips = 1

let g:UltiSnipsSnippetDir=$VIMHOME."UltiSnips"
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsEnableSnipMate = 0

augroup dotfiles_ultisnips
    autocmd!
    " Disable modelines for snippets files. Otherwise vim might try to
    " interpret snippets creating such modelines.
    autocmd FileType snippets setlocal nomodeline
augroup END
