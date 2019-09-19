" ---------------------------------------------------------------------------
"
" vim-test
"
" ---------------------------------------------------------------------------
if !has_key(g:plugs, 'vim-test')
    finish
endif

let test#strategy = "dispatch"
let g:test#preserve_screen = 1

" Copied directly from vim-test's README
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
