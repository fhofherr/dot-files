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
