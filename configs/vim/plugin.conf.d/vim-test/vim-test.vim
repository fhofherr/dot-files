" ---------------------------------------------------------------------------
"
" vim-test
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('vim-test') || exists('g:did_cfg_vim_test')
    finish
endif
let g:did_cfg_vim_test = 1

if dotfiles#plugin#selected('vim-dispatch')
    let test#strategy = 'dispatch'
endif
let g:test#preserve_screen = 1

" Default options for go test
let g:test#go#gotest#options = '-timeout 30s'

" Copied directly from vim-test's README
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
