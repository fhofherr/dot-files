" ---------------------------------------------------------------------------
"
" UltiSnips
"
" ---------------------------------------------------------------------------
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsExpandTrigger="<c-j>"

augroup load_us
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips')
                     \| autocmd! load_us
augroup END
